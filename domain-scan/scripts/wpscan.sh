#!/bin/bash

WORDPRESS_DOMAINS=${1}

# Make Ruby happy :(
source ~/.rvm/scripts/rvm
rvm use 2.3.1 >/dev/null 2>&1

OLD_PWD=$(pwd)
while read WP_DOMAIN; do
    cd ${BATTALION_WPSCAN_HOME}

    if [ ! -z "$WP_DOMAIN" ]; then
        (>&2 echo -e "\t+ Running wpscan for domain [$WP_DOMAIN]")
        ruby wpscan.rb \
            --batch --no-color --follow-redirection \
            --url "$WP_DOMAIN" \
            > $WORDPRESS_DIRECTORY/$WP_DOMAIN.txt
    fi

    cd $OLD_PWD
done <${WORDPRESS_DOMAINS}

