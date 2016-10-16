#!/bin/bash

BASE_DOMAIN_REPORT="${1}"

while read RECORD
do
    # For each record determine whether it's an A record 
    # and print the domain if so.
    RECORD_TYPE=$(echo "${RECORD}" | cut -d' ' -f1)
    DOMAIN=$(echo "${RECORD}" | cut -d' ' -f2)

    if [ "${RECORD_TYPE}" = "A" ]; then
        echo "${DOMAIN}"
    fi
done < "${BASE_DOMAIN_REPORT}"
