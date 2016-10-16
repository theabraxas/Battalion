#!/bin/bash
#
# Invoke EyeWitness upon a list of subdomains. Note that we need to change directories to ensure that
# EyeWitness will work properly. This does not operate on standard input/output, and EyeWitness will 
# create and populate a new directory.

EYEWITNESS_HOME=$1
REPORT_TARGET=$2
SUBDOMAIN_LIST=$3
TIMEOUT_SECONDS="${4}"

rm -fr ${REPORT_TARGET} || true

OLD_PWD=$(pwd)
cd $EYEWITNESS_HOME

./EyeWitness.py \
    -f "${SUBDOMAIN_LIST}" \
    -d "${REPORT_TARGET}" \
    --timeout ${TIMEOUT_SECONDS} \
    --headless --rdp --vnc --no-prompt --prepend-https \
    > /dev/null

cd ${OLD_PWD}
