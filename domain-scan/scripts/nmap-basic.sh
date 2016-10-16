#!/bin/bash

SCAN_DIRECTORY="${1}"

while read SUBDOMAIN
do
    (>&2 echo -e "\t+ Executing light Nmap scan for domain [${SUBDOMAIN}]")
    nmap -T4 --open -F -Pn ${SUBDOMAIN} > "${SCAN_DIRECTORY}/${SUBDOMAIN}.txt"
done < /dev/stdin
