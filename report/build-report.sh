#!/bin/bash

# TODO This is just a shell that we need to fill out.

NOW=$(date +%Y-%m-%d:%H:%M:%S)

cat << EOF > $REPORT
# $SCAN_NAME
$NOW

## Human Intelligence Overview

## Domain Intelligence Overview 

EOF
