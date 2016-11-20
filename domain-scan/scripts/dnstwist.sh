#!/bin/bash
#
# Generate a DNSTwist report using DNSTwist
# Arguments specify to only find registered domains .

TARGET_DOMAIN="${1}"

${BATTALION_DNSTWIST_HOME}/dnstwist.py $TARGET_DOMAIN -j -r -b -m -t 15 < /dev/stdin
