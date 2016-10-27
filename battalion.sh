#!/bin/bash

usage() {
    echo "Usage: battalion --name <name> --out <dir> --domain <domain> --company <company> [optional parameters] [--help]"
    echo ""
    echo "Required Parameters:"
    echo "    --name           <scan name>     Scan name that appears in output."
    echo "    --out            <absolute path> Output directory for scan, should be an absolute path that exists."
    echo ""
    echo "Required Parameters for Domain Scan:"
    echo "    --domain         <domain>        Domain being targeted by scan (example: google.com)."
    echo ""
    echo "Required Parameters for User Scan:"
    echo "    --company        <company name>  Company name as it appears on LinkedIn." 
    echo ""
    echo "Optional Parameters:"
    echo "    --subdomain-list     <file>    File containing subdomains to verify."
    echo "    --email-domain       <domain>  Used to set an email domain name (default is domain name)."
    echo "    --nmap                         If this flag is set, Nmap scanning is added to the domain scan."
    echo "    --shodan             <api key> Sets a Shodan API Key and adds Shodan to the domain scan."
    echo "    --hunter             <api key> Sets a Hunter API Key and enables Hunter in the User scan."
    echo "    --timeout-http       <seconds> Configure the timeout in seconds for HTTP detection."
    echo "    --timeout-eyewitness <seconds> Configure the timeout in seconds for EyeWitness."
    echo ""
    echo "Scan Types:"
    echo "    --disable-domain         Disable the domain scan."
    echo "    --disable-user           Disable the user scan."
    echo ""
    echo "Additional Parameters:"
    echo "    --help Display this usage text."
    echo ""
    echo "Subdomain Lists:"
    echo -n "The subdomain list file is used to specify potential subdomains to test to see if they exist."
    echo -n "You can generate a file yourself, or you can use a premade file. The dnsrecon tool that Battalion"
    echo -n -e "uses to perform these scans provides lists that we recommend utilizing.\n"
    echo ""
}

usage_short() {
    echo "Usage: battalion --name <name> --out <dir> --domain <domain> --company <company> [optional parameters] [--help]"
    echo "Please use --help for more information."
}

export SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export BATTALION_DNSRECON_HOME=${BATTALION_DNSRECON_HOME:-$SCRIPT_DIRECTORY/tools/dnsrecon}
export BATTALION_EYEWITNESS_HOME=${BATTALION_EYEWITNESS_HOME:-$SCRIPT_DIRECTORY/tools/EyeWitness}
export BATTALION_HARVESTER_HOME=${BATTALION_HARVESTER_HOME:-$SCRIPT_DIRECTORY/tools/theHarvester}
export BATTALION_WHATWEB_HOME=${BATTALION_WHATWEB_HOME:-$SCRIPT_DIRECTORY/tools/WhatWeb}
export BATTALION_WPSCAN_HOME=${BATTALION_WPSCAN_HOME:-$SCRIPT_DIRECTORY/tools/wpscan}

if [ $# -eq 0 ]; then
    usage_short
    exit 0
fi

DOMAIN_SCAN_ENABLED=true
USER_SCAN_ENABLED=true

while [[ $# -gt 0 ]]
do
    KEY="$1"

    case $KEY in
        --disable-domain)
            export DOMAIN_SCAN_ENABLED=false
            ;;
        --disable-user)
            export USER_SCAN_ENABLED=false
            ;;
        --name)
            SCAN_NAME="$2"
            shift
            ;;
        --out)
            SCAN_DIRECTORY="$2"
            shift
            ;;
        --domain)
            DOMAIN_TARGET="$2"
            shift
            ;;
        --subdomain-list)
            DOMAIN_SUBDOMAIN_LIST="$2"
            shift
            ;;
        --timeout-http)
            DOMAIN_HTTP_SCAN_TIMEOUT="$2"
            shift
            ;;
        --timeout-eyewitness)
            EYEWITNESS_TIMEOUT="$2"
            shift
            ;;
        --nmap)
            NMAP_ENABLED=true
            ;;
        --shodan)
            export SHODAN_ENABLED=true
            SHODAN_API_KEY="$2"
            shift
            ;;
        --hunter)
            export HUNTER_ENABLED=true
            HUNTER_API_KEY="$2"
            shift
            ;;
        --company)
            COMPANY_NAME="$2"
            shift
            ;;
        --email-domain)
            EMAIL_DOMAIN="$2"
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo "Unrecognized parameter '$1'"
            echo ""
            exit 1
            ;;
    esac
    shift
done

export SCAN_NAME
export DOMAIN_TARGET
export SHODAN_API_KEY
export HUNTER_API_KEY
export COMPANY_NAME
export DOMAIN_SUBDOMAIN_LIST=${DOMAIN_SUBDOMAIN_LIST:-$BATTALION_DNSRECON_HOME/subdomains-top1mil-20000.txt}
export DOMAIN_HTTP_SCAN_TIMEOUT=${DOMAIN_HTTP_SCAN_TIMEOUT:-3}
export EYEWITNESS_TIMEOUT=${EYEWITNESS_TIMEOUT:-15}
export NMAP_ENABLED=${NMAP_ENABLED:-false}
export SHODAN_ENABLED=${SHODAN_ENABLED:-false}
export HUNTER_ENABLED=${HUNTER_ENABLED:-false}
export EMAIL_DOMAIN=${EMAIL_DOMAIN:-$DOMAIN_TARGET}

CONFIGURATION_ERROR=false

if [ -z "${SCAN_NAME}" ]; then
    echo "[Error] The scan name must be configured."
    CONFIGURATION_ERROR=true
fi

if [ -z "${SCAN_DIRECTORY}" ]; then
    echo "[Error] The scan directory must be configured."
    CONFIGURATION_ERROR=true
fi

if $DOMAIN_SCAN_ENABLED && [ -z "${DOMAIN_TARGET}" ]; then
    echo "[Error] The domain target must be configured for domain scans."
    CONFIGURATION_ERROR=true
fi

if $DOMAIN_SCAN_ENABLED && [ -z "${DOMAIN_SUBDOMAIN_LIST}" ]; then
    echo "[Error] A valid subdomain list file must be configured for domain scans."
    CONFIGURATION_ERROR=true
fi

if $USER_SCAN_ENABLED && [ -z "${COMPANY_NAME}" ]; then
    echo "[Error] If the user scan is enabled a company name must be configured."
    CONFIGURATION_ERROR=true
fi

if $CONFIGURATION_ERROR; then
    exit 1
fi

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Prepare scan directory structure.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

export SCAN_DIRECTORY
export DOMAIN_DIRECTORY=$SCAN_DIRECTORY/domain
export WHATWEB_DIRECTORY=$SCAN_DIRECTORY/whatweb
export HTTP_DIRECTORY=$SCAN_DIRECTORY/http
export NMAP_DIRECTORY=$SCAN_DIRECTORY/nmap
export WORDPRESS_DIRECTORY=$SCAN_DIRECTORY/wordpress
export EYEWITNESS_DIRECTORY=$SCAN_DIRECTORY/eyewitness-report
export WHOIS_DIRECTORY=$SCAN_DIRECTORY/whois
export SHODAN_DIRECTORY=$SCAN_DIRECTORY/shodan
export USER_DIRECTORY=$SCAN_DIRECTORY/user
export REPORT_DIRECTORY=$SCAN_DIRECTORY/report

build_dir() {
    mkdir -p "${1}" >/dev/null || true
}

build_dir "${SCAN_DIRECTORY}"
build_dir "${DOMAIN_DIRECTORY}"
build_dir "${WHATWEB_DIRECTORY}"
build_dir "${HTTP_DIRECTORY}"
build_dir "${NMAP_DIRECTORY}"
build_dir "${WORDPRESS_DIRECTORY}"
build_dir "${EYEWITNESS_DIRECTORY}"
build_dir "${WHOIS_DIRECTORY}"
build_dir "${SHODAN_DIRECTORY}"
build_dir "${USER_DIRECTORY}"
build_dir "${REPORT_DIRECTORY}"

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Scan Startup
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

echo ">> Battalion <<"
echo ""
echo "Running scan '${SCAN_NAME}'"
echo ''

export DOMAIN_SCAN_SCRIPTS=$SCRIPT_DIRECTORY/domain-scan/scripts
export USER_SCAN_SCRIPTS=$SCRIPT_DIRECTORY/user-scan/scripts

if $DOMAIN_SCAN_ENABLED ; then
    $SCRIPT_DIRECTORY/domain-scan/domain-scan.sh &
    DOMAIN_SCAN_PID=$!
    echo -e "\t+ Domain scan is enabled and is running with PID ${DOMAIN_SCAN_PID}."
else
    echo -e "\t- Domain scan is disabled."
fi

# Note that due to how the user scan polls HaveIBeenPwned, it currently runs extremely
# slowly and will probably outlive the rest of the scanning.
if $USER_SCAN_ENABLED ; then
    export LINKEDIN_RESULTS=${SCAN_DIRECTORY}/user/linkedin-users.txt
    export POSSIBLE_EMAILS=${SCAN_DIRECTORY}/user/possible-emails.txt
    export COMPROMISED_STYLE=${SCAN_DIRECTORY}/user/compromised-style.txt
    export PROBABLE_EMAILS=${SCAN_DIRECTORY}/user/probable-emails.txt
    export COMPROMISED_EMAILS=${SCAN_DIRECTORY}/user/compromised-emails.txt

    $SCRIPT_DIRECTORY/user-scan/user-scan.sh &
    USER_SCAN_PID=$!
    echo -e "\t+ User scan is enabled and is running with PID ${USER_SCAN_PID}."
else
    echo -e "\t- User scan is disabled."
fi

echo ""

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Wait for the scans to complete 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

if $DOMAIN_SCAN_ENABLED ; then
    wait $DOMAIN_SCAN_PID
    echo "Domain scan complete."
fi

if $USER_SCAN_ENABLED ; then
    wait $USER_SCAN_PID
    echo "User scan complete."
fi

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Build the report
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

export REPORT=$REPORT_DIRECTORY/report.md
$SCRIPT_DIRECTORY/report/build-report.sh

# 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Part X - Complete!
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 

echo ""
echo "Completed scan '${SCAN_NAME}' in directory ${SCAN_DIRECTORY}"
