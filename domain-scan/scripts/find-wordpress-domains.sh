#!/bin/bash
#
# Read WhatWeb scan results and extract WordPress information.
# We know that each file in the WhatWeb output directory represents
# a single subdomain, so we scan each file for WordPress support.

WHATWEB_RAW_DATA=${1}

for WHATWEB_RAW_FILE in ${WHATWEB_RAW_DATA}/*.txt; do
    FILE_BASENAME=`basename ${WHATWEB_RAW_FILE}`
    SUBDOMAIN=${FILE_BASENAME%.*}
    INDICATOR=$(grep '\[\s*WordPress\s*\]' ${WHATWEB_RAW_FILE})

    if [ ! -z "${INDICATOR}" ]; then
        echo ${SUBDOMAIN}
    fi
done
