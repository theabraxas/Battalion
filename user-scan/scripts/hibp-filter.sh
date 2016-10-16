#!/bin/bash
#
# Given a set of probable emails, attempt to narrow down the list using
# HaveIBeenPwned -- if any emails match, consider them "valid".
#
# The input should look like:
#
# probable_email_type|email
#
# Please see the probable-emails.sh script for more information on this
# format. Matched emails will output their type.

HIBP_REQUEST="https://haveibeenpwned.com/api/v2/breachedaccount/"
HIBP_PARAMS="?truncateResponse=True"

handle_potential_email() {
    IFS='|' read -r -a DESCRIPTOR <<< "${1}"
    STYLE="${DESCRIPTOR[0]}"
    EMAIL="${DESCRIPTOR[1]}"

    RESULT=`curl -s ${HIBP_REQUEST}${EMAIL}${HIBP_PARAMS}`
    if [ ! -z "${RESULT// }" ]; then
        echo "${1}"
    fi
}

while read LINE
do
    handle_potential_email "${LINE}"
done < /dev/stdin
