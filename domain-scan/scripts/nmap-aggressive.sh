#!/bin/bash

OUTPUT_DIRECTORY="${1}"

while read SUBDOMAIN
do
    (>&2 echo -e "\t+ Executing aggressive NMAP scan for domain [$SUBDOMAIN]")
    nmap -T4 -A -Pn -sC -p- $SUBDOMAIN -oX "$OUTPUT_DIRECTORY/$SUBDOMAIN.xml" > "$OUTPUT_DIRECTORY/$SUBDOMAIN.txt"
done < /dev/stdin
