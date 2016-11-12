#!/bin/bash

# Apply a filter to all of the names to strip bad words and characters.

while read NAME
do
    $USER_SCAN_SCRIPTS/strip-name.sh "$NAME" < $SCRIPT_DIRECTORY/user-scan/name-bad-word-list
done < "${1:-/dev/stdin}"
