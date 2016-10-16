#!/bin/bash

SCAN_DIRECTORY="${1}"
SHODAN_API_KEY="${2}"

while read IP_ADDRESS
do
    (>&2 echo -e "\t+ Executing Shodan scan for IP address [${IP_ADDRESS}]")
    curl -s -X GET \
        "https://api.shodan.io/shodan/host/${IP_ADDRESS}?key=${SHODAN_API_KEY}" \
        > "${SCAN_DIRECTORY}/${IP_ADDRESS}.txt"
done < /dev/stdin
