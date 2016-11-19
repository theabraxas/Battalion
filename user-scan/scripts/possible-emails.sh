#!/bin/bash
#
# Given a domain and a list of names, generate a set of potential emails
# for every name. The output format is:
#
# email_style|email
#
# About Email Styles
# ==============================================
# Email styles are different combinations of name parts. We utilize four variables:
# 
# - {first} = First name
# - {last}  = Last name
# - {f}     = First letter of first name
# - {l}     = First letter of last name
#
# Those variables might be mixed with common characters as well. For instances we
# might have {f}{last}@domain.com or {first}-{last}@domain.com
#

EMAIL_DOMAIN=$1

handle_name() {
    FIRST_NAME=$1
    LAST_NAME=$2
    FIRST_LETTER=${1:0:1}
    LAST_LETTER=${2:0:1}

    # First name followed by last name
    echo "{first}.{last}|${FIRST_NAME}.${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "{first}_{last}|${FIRST_NAME}_${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "{first}-{last}|${FIRST_NAME}-${LAST_NAME}@${EMAIL_DOMAIN}"

    # Last name followed by first name
    echo "{last}.{first}|${LAST_NAME}.${FIRST_NAME}@${EMAIL_DOMAIN}"
    echo "{last}_{first}|${LAST_NAME}_${FIRST_NAME}@${EMAIL_DOMAIN}"
    echo "{last}-{first}|${LAST_NAME}-${FIRST_NAME}@${EMAIL_DOMAIN}"

    # Letter followed by name
    echo "{f}{last}|${FIRST_LETTER}${LAST_NAME}@${EMAIL_DOMAIN}"
    echo "{l}{first}|${LAST_LETTER}${FIRST_NAME}@${EMAIL_DOMAIN}"
    
    # Name followed by letter
    echo "{last}{f}|${LAST_NAME}${FIRST_LETTER}@${EMAIL_DOMAIN}"
    echo "{first}{l}|${FIRST_NAME}${LAST_LETTER}@${EMAIL_DOMAIN}"
}

while read LINE
do
    # Process an individual line. For the name, generate all possible emails.
    IFS=' ' read -r -a FULL_NAME <<< "${LINE}"
    handle_name "${FULL_NAME[0]}" "${FULL_NAME[1]}"
done < /dev/stdin
