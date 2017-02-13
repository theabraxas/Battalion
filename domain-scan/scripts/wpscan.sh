#!/bin/bash

WORDPRESS_DOMAINS=${1}

# Make Ruby happy :(
source ~/.rvm/scripts/rvm
rvm use 2.3.3 >/dev/null 2>&1

OLD_PWD=$(pwd)
while read WP_DOMAIN; do
    RAW_OUTPUT=$WORDPRESS_DIRECTORY/$WP_DOMAIN.txt
    JSON_OUTPUT=$WORDPRESS_DIRECTORY/$WP_DOMAIN.json

    cd $BATTALION_WPSCAN_HOME

    if [ ! -z "$WP_DOMAIN" ]; then
        (>&2 echo -e "\t+ Running wpscan for domain [$WP_DOMAIN]")
        ruby wpscan.rb \
            --batch --no-color --follow-redirection --no-banner \
            --url "$WP_DOMAIN" \
            > $RAW_OUTPUT
    fi

    cd $OLD_PWD

    python $DOMAIN_SCAN_SCRIPTS/parse-wpscan.py $RAW_OUTPUT $JSON_OUTPUT

done <${WORDPRESS_DOMAINS}

