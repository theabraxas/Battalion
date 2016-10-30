#!/bin/bash
#
# Search for all subdomains of the target domain.
# We want to match on all domains that contain the target domain.

BASE_DOMAIN_REPORT=$1
DOMAIN_TARGET="$2"

cat $BASE_DOMAIN_REPORT | jq -M -c '.domainRecords | [.[] | if (.domain | contains("'"$DOMAIN_TARGET"'")) then .domain else empty end | ascii_downcase] | unique | {subdomains: .}'
