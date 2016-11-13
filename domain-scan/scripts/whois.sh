#!/bin/bash 

DOMAIN_TARGET=${1}
WHOIS_SCAN_DIRECTORY=${2}
FILE_BASENAME="${WHOIS_SCAN_DIRECTORY}/${DOMAIN_TARGET}"

ruby -r 'whois' -e 'puts Whois::Client.new(:timeout => 30).lookup("'"${DOMAIN_TARGET}"'")' > "${FILE_BASENAME}.raw.txt" 

RNAME=`grep "Registrant Name" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
REMAIL=`grep "Registrant Email" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
RADDR1=`grep "Registrant Street" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
RADDR2=`grep "Registrant City" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
RADDR3=`grep "Registrant State" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
RADDR4=`grep "Registrant Postal" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TNAME=`grep "Tech Name" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TEMAIL=`grep "Tech Email" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TADDR1=`grep "Tech Street" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TADDR2=`grep "Tech City" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TADDR3=`grep "Tech State" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
TADDR4=`grep "Tech Postal" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`
REGI=`grep -A0 "Registrar:" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //' | tail -n1`
REXPD=`grep "Registrar Registration Expiration Date" "${FILE_BASENAME}.raw.txt" | sed 's/.*: //'`

echo '{"whois" : {"registrantName":"'"$RNAME"'","registrantEmail":"'"$RMEAIL"'","registrantAddress":"'"$RADDR1 $RADDR2 $RADDR3 $RADDR4"'","techName":"'"$TNAME"'","techEmail":"'"$TEMAIL"'","techAddress":"'"$TADDR1 $TADDR2 $TADDR3 $TADDR4"'","registrar":"'"$REGI"'","domainExirationDate":"'"$REXPD"'"}}' > "${FILE_BASENAME}.json"
 

cat "${FILE_BASENAME}.raw.txt" \
    | grep -E 'Registrar:|Referral URL:|Creation Date:|Expiration Date:|DNSSEC:|Registratnt Name:|Registrant Organization:|Registrant Street:|Registrant City:|Registrant State/Province:|Registrant Phone:|Registrant Email:|Admin Name:|Admin Street:|Admin City:|Admin State/Province:|Admin Phone:|Admin Email:|Tech Name:|Tech Street:|Tech City:|Tech State/Province:|Tech Phone:|Tech Email:' \
    | grep --invert-match 'Registrar Registration Expiration Date:' \
    | sed -e 's/^[[:space:]]*//' \
    > "${FILE_BASENAME}.txt"
