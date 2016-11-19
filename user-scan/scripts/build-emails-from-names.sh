#!/bin/bash
#
# Given a list of names - one per line - generate a list of email addresses
# from those names.

while read LINE
do
    echo "$LINE@$EMAIL_DOMAIN"
done < ${1:-/dev/stdin}
