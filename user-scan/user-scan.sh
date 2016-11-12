#!/bin/bash

echo "> Attempting to harvest users for company '$COMPANY_NAME' from LinkedIn."

$USER_SCAN_SCRIPTS/harvest-linkedin.sh "$COMPANY_NAME" 100 \
    | $USER_SCAN_SCRIPTS/clean-harvested-names.sh \
    | uniq -u \
    > $LINKEDIN_RESULTS

echo -e "\t+ Found $(cat $LINKEDIN_RESULTS | wc -l) users."
echo ""

touch $POSSIBLE_EMAILS
$USER_SCAN_SCRIPTS/possible-emails.sh "$EMAIL_DOMAIN" \
    < $LINKEDIN_RESULTS \
    > $POSSIBLE_EMAILS

echo "> Attempting to identify compromised email style based on HaveIBeenPwned."

touch $COMPROMISED_STYLE
$USER_SCAN_SCRIPTS/hibp-filter.sh \
    < $POSSIBLE_EMAILS \
    > $COMPROMISED_STYLE

touch $PROBABLE_EMAILS
touch $COMPROMISED_EMAILS
if [ -s $COMPROMISED_STYLE ]; then
    cat $POSSIBLE_EMAILS | grep $COMPROMISED_STYLE > $PROBABLE_EMAILS
    cat $PROBABLE_EMAILS \
        | $USER_SCAN_SCRIPTS/hibp-scan.sh \
        > $COMPROMISED_EMAILS
fi
