#!/bin/bash

LINKEDIN_RESULTS=${SCAN_DIRECTORY}/user/linkedin-users.txt
PROBABLE_EMAILS=${SCAN_DIRECTORY}/user/probable-emails.txt
COMPROMISED_EMAILS=${SCAN_DIRECTORY}/user/compromised-emails.txt

echo "> Attempting to harvest users for company '${COMPANY_NAME}' from LinkedIn."

$SCRIPT_DIRECTORY/user-scan/scripts/harvest-linkedin.sh "${COMPANY_NAME}" 100 > $LINKEDIN_RESULTS

echo -e "\t+ Found $(cat $LINKEDIN_RESULTS | wc -l) users."
echo ""

touch $PROBABLE_EMAILS
$SCRIPT_DIRECTORY/user-scan/scripts/probable-emails.sh "${EMAIL_DOMAIN}" \
    < $LINKEDIN_RESULTS \
    > $PROBABLE_EMAILS

echo "> Attempting to identify compromised emails based on HaveIBeenPwned."

touch $COMPROMISED_EMAILS
$SCRIPT_DIRECTORY/user-scan/scripts/hibp-filter.sh \
    < $PROBABLE_EMAILS \
    > $COMPROMISED_EMAILS
