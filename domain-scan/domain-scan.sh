#!/bin/bash

export DOMAIN_SCAN_SCRIPTS=$SCRIPT_DIRECTORY/domain-scan/scripts

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 1 - dnsrecon domain scan
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
echo "> Executing domain scan on $DOMAIN_TARGET using subdomain list $DOMAIN_SUBDOMAIN_LIST"

BASE_DOMAIN_REPORT=$DOMAIN_DIRECTORY/base-domain-report.txt
A_RECORD_LIST=$DOMAIN_DIRECTORY/a-records.txt
IP_ADDRESS_LIST=$DOMAIN_DIRECTORY/a-record-ip-addresses.txt
SUBDOMAIN_LIST=$DOMAIN_DIRECTORY/subdomains.txt
CNAME_LIST=$DOMAIN_DIRECTORY/cnames.txt
HTTP_SUBDOMAIN_LIST=$DOMAIN_DIRECTORY/http-subdomains.txt
DNSTWIST_LIST=$DOMAIN_DIRECTORY/dnstwist.txt

$DOMAIN_SCAN_SCRIPTS/run-domain-scan.sh \
    "$DOMAIN_TARGET" 15 $DOMAIN_SUBDOMAIN_LIST \
    > $BASE_DOMAIN_REPORT

# Produce a list of only the A records
$DOMAIN_SCAN_SCRIPTS/filter-a-records.sh $BASE_DOMAIN_REPORT \
    > $A_RECORD_LIST

# Produce a list of all IP Addresses of A records that match our primary domain name.
$DOMAIN_SCAN_SCRIPTS/filter-ip-addresses.sh $A_RECORD_LIST "$DOMAIN_TARGET" \
    > $IP_ADDRESS_LIST

# Identify all valid subdomains that match our primary domain name.
$DOMAIN_SCAN_SCRIPTS/filter-subdomains.sh $BASE_DOMAIN_REPORT "$DOMAIN_TARGET" \
    > $SUBDOMAIN_LIST

# Map CNAME records back to IP addresses
$DOMAIN_SCAN_SCRIPTS/map-cname-records.py "$DOMAIN_TARGET" $BASE_DOMAIN_REPORT \
    > $CNAME_LIST

# Identify all subdomains that support HTTP(s) connections.
echo ""
echo "> Identifying domains that support HTTP(s) connections for additional scanning"

cat $SUBDOMAIN_LIST \
    | jq -M -r -c '.subdomains | .[]' \
    | $DOMAIN_SCAN_SCRIPTS/find-http-domains.sh "$DOMAIN_HTTP_SCAN_TIMEOUT" \
    > $HTTP_SUBDOMAIN_LIST

echo -e "\t- Identified $(cat $HTTP_SUBDOMAIN_LIST | wc -l) subdomains that support HTTP(s)"

echo ""
echo "> Executing dnstwist scan on $DOMAIN_TARGET to find similar looking registered domains"

$DOMAIN_SCAN_SCRIPTS/dnstwist.sh "$DOMAIN_TARGET" \
     > "$DNSTWIST_LIST"


# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 2a - EyeWitness
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
echo ""
echo "> Using EyeWitness to visually inspect all HTTP(s) subdomains."

$DOMAIN_SCAN_SCRIPTS/eyewitness.sh $BATTALION_EYEWITNESS_HOME \
    $SCAN_DIRECTORY/eyewitness-report \
    $HTTP_SUBDOMAIN_LIST \
    $EYEWITNESS_TIMEOUT &

EYEWITNESS_PID=$!

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 2b - WhatWeb
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
echo "> Using WhatWeb to analyze all HTTP(s) subdomains."

$DOMAIN_SCAN_SCRIPTS/whatweb.sh $WHATWEB_DIRECTORY $HTTP_SUBDOMAIN_LIST &
WHATWEB_PID=$!

#
# Part 2 - Wait for processes to complete.
#
echo ""
echo "> Waiting for EyeWitness and WhatWeb to complete..."
echo -e "\t+ EyeWitness abort:(kill $EYEWITNESS_PID)"
echo -e "\t+ WhatWeb    abort:(kill $WHATWEB_PID)"
echo ""

wait $EYEWITNESS_PID
wait $WHATWEB_PID

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 3 - WhatWeb Filtering
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

WORDPRESS_LIST=$HTTP_DIRECTORY/wordpress-domains
$DOMAIN_SCAN_SCRIPTS/find-wordpress-domains.sh $WHATWEB_DIRECTORY \
    | uniq -i \
    > $WORDPRESS_LIST

echo "> Extracted $(cat $WORDPRESS_LIST | wc -l) domains using WordPress from WhatWeb results"

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 4 - Nmap (If Enabled)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
if $NMAP_ENABLED ; then
    echo ""
    echo "> Executing Nmap scan on all subdomains."

    cat $SUBDOMAIN_LIST | jq -M -r -c '.subdomains | .[]' | uniq -i | $DOMAIN_SCAN_SCRIPTS/nmap-basic.sh $NMAP_DIRECTORY

    echo -e "\t- Produced $(ls -1 ${NMAP_DIRECTORY} | wc -l) Nmap reports."

elif $NMAP_AGGRESSIVE_ENABLED ; then
    echo ""
    echo "> Executing Aggressive Nmap scan on all subdomains."

    cat $SUBDOMAIN_LIST | jq -M -r -c '.subdomains | .[]' | uniq -i | $DOMAIN_SCAN_SCRIPTS/nmap-aggressive.sh $NMAP_DIRECTORY

    echo -e "\t- Produced $(ls -1 ${NMAP_DIRECTORY} | wc -l) Nmap reports."

else
    echo ""
    echo "! Nmap disabled for this scan"
fi

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 5 - WPScan for WordPress Domains
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
echo ""
echo "> Scanning $(cat ${WORDPRESS_LIST} | wc -l) domains for WordPress information and vulnerabilities."
$DOMAIN_SCAN_SCRIPTS/wpscan.sh $WORDPRESS_LIST

echo -e "\t- Executed $(ls -1 $WORDPRESS_DIRECTORY | wc -l) WordPress scans."


# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 6 - WHOIS 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 
echo ""
echo "> Parsing WHOIS report for $DOMAIN_TARGET"

$DOMAIN_SCAN_SCRIPTS/whois.sh "$DOMAIN_TARGET" $WHOIS_DIRECTORY


# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part 7 - Shodan (If Enabled)
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

if $SHODAN_ENABLED ; then
    echo ""
    echo "> Executing Shodan scan on $(cat $IP_ADDRESS_LIST | wc -l) IP addresses."

    cat $IP_ADDRESS_LIST | jq -M -r -c '.primaryIPAddresses | .[]' | $DOMAIN_SCAN_SCRIPTS/shodan.sh $SHODAN_DIRECTORY "${SHODAN_API_KEY}"

    echo -e "\t- Produced $(ls -1 $SHODAN_DIRECTORY | wc -l) Shodan reports."
else
    echo ""
    echo "! Shodan disabled for this scan"
fi
