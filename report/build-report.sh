#!/bin/bash

# TODO This is just a shell that we need to fill out.

NOW=$(date +%Y-%m-%d:%H:%M:%S)

cat << EOF > $REPORT
# $SCAN_NAME
$NOW

## Human Intelligence Overview

- Number of current or former employees identified: $(wc -l < $LINKEDIN_RESULTS)

EOF
