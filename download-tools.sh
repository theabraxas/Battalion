#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $SCRIPT_DIRECTORY/tools || true >/dev/null 2>&1

git clone https://github.com/darkoperator/dnsrecon $SCRIPT_DIRECTORY/tools/dnsrecon
git clone https://github.com/ChrisTruncer/EyeWitness $SCRIPT_DIRECTORY/tools/EyeWitness
git clone https://github.com/laramies/theHarvester $SCRIPT_DIRECTORY/tools/theHarvester
git clone https://github.com/urbanadventurer/WhatWeb $SCRIPT_DIRECTORY/tools/WhatWeb
git clone https://github.com/wpscanteam/wpscan $SCRIPT_DIRECTORY/tools/wpscan
git clone https://github.com/elceef/dnstwist $SCRIPT_DIRECTORY/tools/dnstwist
