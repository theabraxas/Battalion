#!/bin/bash

# Use hunter to determine the most common email pattern, returning that pattern
# to use for HIBP.

# Note that each unique scan made against Hunter.io will consume a credit from your
# account. Please only enable Hunter if you have credits available and want to use
# them to augment your Battalion results.

HUNTER_API_REQUEST="https://api.hunter.io/v2/domain-search?domain=${DOMAIN_TARGET}&api_key=${HUNTER_API_KEY}"
HUNTER_RESPONSE="$(curl -s -w "\n\n<%{http_code}>" $HUNTER_API_REQUEST)"
STATUS_CODE="$(echo "$HUNTER_RESPONSE" | tail -n 1)"
BODY="$(echo "$HUNTER_RESPONSE" | head -n -2)"

# Expect response: 200 OK for successful results (reject everything else)
if [ "$STATUS_CODE" = "<200>" ]; then
    # Parse the response (JSON) using jq
    PATTERN="$(echo "$BODY" | jq -M -c -r '.data.pattern')"
    echo "$PATTERN"
else
    >&2 echo "! Failed to query Hunter.io and received a status code '$STATUS_CODE'"
    >&2 echo "! Please ensure that you are utilizing a valid API key."
fi
