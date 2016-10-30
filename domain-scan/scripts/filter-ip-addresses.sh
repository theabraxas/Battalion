#!/bin/bash

A_RECORD_LIST=$1
DOMAIN_TARGET=$2

cat $A_RECORD_LIST | jq -M -c '.aRecords | [.[] | if (.domain | contains("'"$DOMAIN_TARGET"'")) then .target else empty end] | unique | {primaryIPAddresses: .}'
