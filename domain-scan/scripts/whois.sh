#!/bin/bash 

DOMAIN_TARGET=${1}
WHOIS_SCAN_DIRECTORY=${2}
FILE_BASENAME="${WHOIS_SCAN_DIRECTORY}/${DOMAIN_TARGET}"

ruby -r 'whois' -e 'puts Whois::Client.new(:timeout => 30).lookup("'"${DOMAIN_TARGET}"'")' > "${FILE_BASENAME}.raw.txt" 

cat "${FILE_BASENAME}.raw.txt" \
    | grep -E 'Registrar:|Referral URL:|Creation Date:|Expiration Date:|DNSSEC:|Registratnt Name:|Registrant Organization:|Registrant Street:|Registrant City:|Registrant State/Province:|Registrant Phone:|Registrant Email:|Admin Name:|Admin Street:|Admin City:|Admin State/Province:|Admin Phone:|Admin Email:|Tech Name:|Tech Street:|Tech City:|Tech State/Province:|Tech Phone:|Tech Email:' \
    | grep --invert-match 'Registrar Registration Expiration Date:' \
    | sed -e 's/^[[:space:]]*//' \
    > "${FILE_BASENAME}.txt"
