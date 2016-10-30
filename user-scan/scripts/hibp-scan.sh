#!/bin/bash

HIBP_REQUEST="https://haveibeenpwned.com/api/v2/breachedaccount/"
HIBP_PARAMS="?truncateResponse=True"

CURRENT_COUNT=0

print_progress() {
    let CURRENT_COUNT=CURRENT_COUNT+1
    echo -ne "\rScanned $CURRENT_COUNT emails." >&2
}

handle_potential_email() {
    IFS='|' read -r -a DESCRIPTOR <<< "${1}"
    EMAIL="${DESCRIPTOR[1]}"

    RESULT=`curl -s -w "\n\n<%{http_code}>" ${HIBP_REQUEST}${EMAIL}${HIBP_PARAMS}`
    STATUS_CODE=$(echo $RESULT | tail -n 1)
    BODY=$(echo $RESULT | head -n -2)

    if [ "$STATUS_CODE" = "<200>" ] && [ ! -z "${BODY// }" ]; then
        echo "${1}"
    else
        if [ "$STATUS_CODE" = "<429>" ]; then
            # Immediately sleep for 5 seconds if we manage to exceed our rate.
            # We want to be polite to HIBP, so give it some time to cool down.
            sleep 5
        fi
    fi
}

while read LINE
do
    handle_potential_email "${LINE}"
    print_progress
    sleep 1.6
done < /dev/stdin
