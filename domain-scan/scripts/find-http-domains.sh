#!/bin/bash
#
# Reads STDIN - each line should represent a subdomain to check.
# Uses curl to verify whether the subdomain supports HTTP. Only retain
# subdomains that expose standard HTTP ports.

CONNECT_TIMEOUT=${1}

check_https() {
    SUBDOMAIN=${1}
    curl -s \
        --connect-timeout ${CONNECT_TIMEOUT} --max-time ${CONNECT_TIMEOUT} \
        "${SUBDOMAIN}:443" >/dev/null && echo "${SUBDOMAIN}"
}

check_ports() {
    SUBDOMAIN=${1}
    curl -s \
        --connect-timeout ${CONNECT_TIMEOUT} --max-time ${CONNECT_TIMEOUT} \
        "${SUBDOMAIN}:80" >/dev/null && echo "${SUBDOMAIN}" || check_https ${SUBDOMAIN}
}

while read SUBDOMAIN
do
    # For each subdomain, include it if it supports port 80 or port 443
    (>&2 echo -e "\t+ Checking ports 80/443 for domain [${SUBDOMAIN}]")
    check_ports ${SUBDOMAIN}
done < /dev/stdin
