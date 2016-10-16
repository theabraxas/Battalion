#!/bin/bash
#
# Generate a Domain report using DNSRecon.
# We strip some of the unimportant banner text and summary information.

TARGET_DOMAIN="${1}"
DOMAIN_SCAN_THREAD_LIMIT="${2}"
SUBDOMAIN_LIST_FILE="${3}"

echo "THE HOME IS ALSO ${BATTALION_DNSRECON_HOME}"

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
