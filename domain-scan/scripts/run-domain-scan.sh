#!/bin/bash
#
# Generate a Domain report using DNSRecon.
# We strip some of the unimportant banner text and summary information.

TARGET_DOMAIN="${1}"
DOMAIN_SCAN_THREAD_LIMIT="${2}"
SUBDOMAIN_LIST_FILE="${3}"

function execute_domain_scan() {
    ${BATTALION_DNSRECON_HOME}/dnsrecon.py \
        -d "${TARGET_DOMAIN}" \
        -t brt \
        -D ${SUBDOMAIN_LIST_FILE} \
        --threads ${DOMAIN_SCAN_THREAD_LIMIT} \
        | tail -n +2 \
        | head -n -1 \
        | cut -c 7- \
        | grep -v ":" \
        | sort -k1,1
}

function convert_record() {
    RECORD_TYPE=$(echo "$1" | cut -d' ' -f1)
    DOMAIN=$(echo "$1" | cut -d' ' -f2)
    TARGET=$(echo "$1" | cut -d' ' -f3)

    echo -n '{"recordType":"'"$RECORD_TYPE"'","domain":"'"$DOMAIN"'","target":"'"$TARGET"'"}'
}

function convert_raw_to_json() {
    IS_FIRST_LINE=true
    while read -r LINE; do
        # Each line will either be blank or have the format:
        # RECORD_TYPE DOMAIN TARGET
        # where each element is separated by a single space.
        if [ ! -z "$LINE" ]; then
            if $IS_FIRST_LINE; then
                IS_FIRST_LINE=false
            else
                echo -n ","
            fi
            convert_record "$LINE"
        fi
    done <<< "$1"
}

RAW_OUTPUT=$(execute_domain_scan)

echo -n '{"domainRecords":['
convert_raw_to_json "$RAW_OUTPUT"
echo -n ']}'
