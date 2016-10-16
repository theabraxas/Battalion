#!/bin/bash

BASE_DOMAIN_REPORT="${1}"
TARGET_DOMAIN="${2}"

while read RECORD
do
    RECORD_TYPE=$(echo "${RECORD}" | cut -d' ' -f1)
    DOMAIN=$(echo "${RECORD}" | cut -d' ' -f2)
    IP_ADDRESS=$(echo "${RECORD}" | cut -d' ' -f3)

    if [ "${RECORD_TYPE}" = "A" ]; then
        MATCH=$(echo "${DOMAIN}" | grep "${TARGET_DOMAIN}")
        if [ ! -z "${MATCH}" ]; then
            echo "${IP_ADDRESS}"
        fi
    fi
done < "${BASE_DOMAIN_REPORT}"
