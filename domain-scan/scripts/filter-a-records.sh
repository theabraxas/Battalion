#!/bin/bash

# We want to filter out all non-A-record elements.
cat $1 | jq -M -c '.domainRecords | [.[] | if (.recordType == "A") then . else empty end] | unique_by(.domain | ascii_downcase) | {aRecords: .}'
