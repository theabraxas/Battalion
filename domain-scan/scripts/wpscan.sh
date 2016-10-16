#!/bin/bash

SCAN_DIRECTORY_ABSOLUTE="${1}"
WORDPRESS_DOMAINS="${2}"

# Make Ruby happy :(
source ~/.rvm/scripts/rvm
rvm use 2.3.1 >/dev/null 2>&1

OLD_PWD=$(pwd)
while read WP_DOMAIN; do
    cd ${BATTALION_WPSCAN_HOME}

    # Each line in the file corresponds to a single domain we want to scan.
    TARGET_DOMAIN=${WP_DOMAIN}

    if [ ! -z "${TARGET_DOMAIN}" ]; then
        (>&2 echo -e "\t+ Running wpscan for domain [${TARGET_DOMAIN}]")
        ruby wpscan.rb \
            --batch --no-color --follow-redirection \
            --url "${TARGET_DOMAIN}" \
            > "${SCAN_DIRECTORY_ABSOLUTE}/${TARGET_DOMAIN}.txt"
    fi

    cd $OLD_PWD
done <${WORDPRESS_DOMAINS}

