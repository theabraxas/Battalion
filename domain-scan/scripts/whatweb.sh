#!/bin/bash

SCAN_DIRECTORY="${1}"
SUBDOMAIN_FILE="${2}"

while read SUBDOMAIN; do
    # For each subdomain, execute WhatWeb and dump the raw results to a file.
    OUTPUT="${SCAN_DIRECTORY}/${SUBDOMAIN}.txt"
    JSONOUTPUT="${SCAN_DIRECTORY}/${SUBDOMAIN}.json"
    ${BATTALION_WHATWEB_HOME}/whatweb --color=never --no-errors -a1 -v "${SUBDOMAIN}" --log-json="${JSONOUTPUT}" > "${OUTPUT}"
done <${SUBDOMAIN_FILE}

