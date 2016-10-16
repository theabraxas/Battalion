#!/bin/bash
#
# Search for all subdomains of the target domain.
# We want to match on all domains that contain the target domain.

BASE_DOMAIN_REPORT="${1}"
DOMAIN_TARGET="${2}"
DOMAIN_MATCH_REGEX=$(echo $DOMAIN_TARGET | sed 's/\./\\./g')

awk '{ print $2 }' ${BASE_DOMAIN_REPORT} | grep ".*\\.${DOMAIN_MATCH_REGEX}$"
