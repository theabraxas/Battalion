#!/bin/bash
#
# Given a domain and a list of names, generate a set of potential emails
# for every name. The output format is:
#
# possible_email_type|email
#
# There are 10 possible email types.
#
# First Name followed by Last Name
# ==============================================
# - fl_dot => FirstName.LastName@domain
# - fl_underscore => FirstName_LastName@domain
# - fl_dash => FirstName-LastName@domain
#
# Last Namee followed by First Name
# ==============================================
# - Same as fl, but reversed.
#
# Initials
# ==============================================
# - fil => FirstInitialLastName@domain
# - lif => LastInitialFirstName@domain
# - lfi => LastNameFirstInitial@domain
# - fli => FristNameLastInitial@domain

EMAIL_DOMAIN=$1

handle_name() {
    FIRST_NAME=$1
    LAST_NAME=$2
    FIRST_LETTER=${1:0:1}
    LAST_LETTER=${2:0:1}

    # First name + Last name
    echo "fl_dot|${FIRST_NAME}.${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "fl_underscore|${FIRST_NAME}_${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "fl_dash|${FIRST_NAME}-${LAST_NAME}@${EMAIL_DOMAIN}"

    # Last name + First name
    echo "lf_dot|${LAST_NAME}.${FIRST_NAME}@${EMAIL_DOMAIN}"
    echo "lf_underscore|${LAST_NAME}_${FIRST_NAME}@${EMAIL_DOMAIN}"
    echo "lf_dash|${LAST_NAME}-${FIRST_NAME}@${EMAIL_DOMAIN}"

    # First and last initials
    echo "fil|${FIRST_LETTER}${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "lif|${LAST_LETTER}${FIRST_NAME}@${EMAIL_DOMAIN}"
    echo "lfi|${LAST_NAME}${FIRST_LETTER}@${EMAIL_DOMAIN}"
    echo "fli|${FIRST_NAME}${LAST_LETTER}@${EMAIL_DOMAIN}"
}

while read LINE
do
    # Process an individual line. For the name, generate all possible emails.
    IFS=' ' read -r -a FULL_NAME <<< "${LINE}"
    handle_name "${FULL_NAME[0]}" "${FULL_NAME[1]}"
done < /dev/stdin
