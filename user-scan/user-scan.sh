#!/bin/bash

echo "> Attempting to harvest users for company '$COMPANY_NAME' from LinkedIn."

$USER_SCAN_SCRIPTS/harvest-linkedin.sh "$COMPANY_NAME" 100 \
    | $USER_SCAN_SCRIPTS/clean-harvested-names.sh \
    | uniq -u \
    > $LINKEDIN_RESULTS

echo -e "\t+ Found $(cat $LINKEDIN_RESULTS | wc -l) users."
echo ""

# Generate a list of possible emails from our LinkedIn results.
# See the script for more information, we just combine names in different ways.
echo "> Populating user emails using the domain $EMAIL_DOMAIN"
touch $POSSIBLE_EMAILS
$USER_SCAN_SCRIPTS/possible-emails.sh "$EMAIL_DOMAIN" \
    < $LINKEDIN_RESULTS \
    > $POSSIBLE_EMAILS

touch $COMPROMISED_STYLE
if $HUNTER_ENABLED; then
    # The user has chosen to use Hunter. Rather than scan using HIBP we'll
    # just look up the best pattern.
    echo -e "> Attempting to identify compromised email style based on Hunter.io."
    echo -e "> This operation uses the Hunter.io API Key that you supplied and will use its credits."

    $USER_SCAN_SCRIPTS/hunter-filter.sh \
        > $COMPROMISED_STYLE
else
    # The user does not want to use Hunter. We'll scan possible emails one-by-one
    # until we encounter a HIBP match and choose that style.
    echo -e "> Attempting to identify compromised email style based on HaveIBeenPwned."
    echo -e "> Scanning a set of $(cat $POSSIBLE_EMAILS | wc -l) potential emails."

    $USER_SCAN_SCRIPTS/hibp-filter.sh \
        < $POSSIBLE_EMAILS \
        > $COMPROMISED_STYLE
fi

# We have identified a style (or haven't found anything useful) -- if we DO have
# a style of email that seems probable, we want to run an HIBP scan against all
# email addresses of that form.
touch $PROBABLE_EMAILS
touch $COMPROMISED_EMAILS

# Append the Battalion standard email list to the probable emails so that they always get
# scanned. It's a small list of non-user accounts that have a good chance of existing.
$USER_SCAN_SCRIPTS/build-emails-from-names.sh $SCRIPT_DIRECTORY/user-scan/standard-email-list > $PROBABLE_EMAILS

if [ -s $COMPROMISED_STYLE ]; then
    echo -e "\t+ Identified the style '$(cat $COMPROMISED_STYLE)'\n"

    # Filter the possible emails by the pattern that we determined to be the most probable.
    # Next we'll run every email matching the pattern through HIBP in an attempt to identify
    # any compromised emails.
    cat $POSSIBLE_EMAILS \
        | grep -F "$(cat $COMPROMISED_STYLE)" \
        | cut -d\| -f 2 \
        >> $PROBABLE_EMAILS
fi

echo -e "> Identified $(cat $PROBABLE_EMAILS | wc -l) probable emails."
echo -e "> Scanning probable emails using HaveIBeenPwned.\n"

cat $PROBABLE_EMAILS \
    | $USER_SCAN_SCRIPTS/hibp-scan.sh \
    > $COMPROMISED_EMAILS

echo ""
