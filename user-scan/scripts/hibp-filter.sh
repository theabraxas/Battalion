#!/bin/bash
#
# Given a set of possible emails, attempt to narrow down the list using
# HaveIBeenPwned -- if any emails match, consider them "valid" and select
# that format in general.
#
# The input should look like:
#
# possible_email_type|email
#
# Please see the possible-emails.sh script for more information on this
# format. Matched emails will output their type.

HIBP_REQUEST="https://haveibeenpwned.com/api/v2/breachedaccount/"
HIBP_PARAMS="?truncateResponse=True"

CURRENT_COUNT=0

print_progress() {
    let CURRENT_COUNT=CURRENT_COUNT+1
    echo -ne "\rScanning emails to find format.  Scanned $CURRENT_COUNT emails." >&2
}

handle_potential_email() {
    IFS='|' read -r -a DESCRIPTOR <<< "${1}"
    STYLE="${DESCRIPTOR[0]}"
    EMAIL="${DESCRIPTOR[1]}"

    RESULT=`curl -s -w "\n\n<%{http_code}>" ${HIBP_REQUEST}${EMAIL}${HIBP_PARAMS}`
    STATUS_CODE=$(echo $RESULT | tail -n 1)
    BODY=$(echo $RESULT | head -n -2)

    if [ "$STATUS_CODE" = "<200>" ] && [ ! -z "${BODY// }" ]; then
        echo "$STYLE"
    fi
}

while read LINE
do
    EMAIL_RESULT=$(handle_potential_email "${LINE}")
    print_progress

    if [ -z "$EMAIL_RESULT" ]; then
        sleep 1.6
    else
        # Break on the first result. This tells us the "Valid format" to select
        echo $EMAIL_RESULT
        exit 0
    fi
done < /dev/stdin
