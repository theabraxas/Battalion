#!/bin/bash

# Strip matched words from names. This is used to remove patterns like:
# 'Jr.', 'Sr.', 'CPA', etc. from names.
#
# The second input (or stdin) is a file containing the words to strip, one per line.
# The first input is the line to strip from.

# echo ${TMP//Mr.} | sed 's/^[ \t]*//' | sed 's/[ \t]*$//' | sed 's/  */ /'

LINE="$1"

while read STRIPPED_WORD
do
    LINE="${LINE//$STRIPPED_WORD}"
done < "${2:-/dev/stdin}"

echo $LINE \
    | sed 's/^[ \t]*//' \
    | sed 's/[ \t]*$//' \
    | sed 's/[ \t][ \t]*/ /'

