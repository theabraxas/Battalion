#!/bin/bash

COMPANY_NAME="$1"
RESULT_LIMIT="$2"
BASE_SKIP=19
REAL_SKIP=$((${BASE_SKIP} + (${RESULT_LIMIT} / 100)))

if [ "${REAL_SKIP}" -lt "20" ]; then
    REAL_SKIP=20
fi

# -d <target> -- for LinkedIn this is the company name
# -l <limit>  -- number of results

python ${BATTALION_HARVESTER_HOME}/theHarvester.py -d "${COMPANY_NAME}" -b linkedin -l ${RESULT_LIMIT} \
    | tail -n +${REAL_SKIP} \
    | sed 's/^ *//;s/ *$//' \
    | uniq -u 
