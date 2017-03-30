#!/bin/bash

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p $SCRIPT_DIRECTORY/tools || true >/dev/null 2>&1

git clone https://github.com/darkoperator/dnsrecon $SCRIPT_DIRECTORY/tools/dnsrecon
cd $SCRIPT_DIRECTORY/tools/dnsrecon
git checkout tags/v0.8.9 -b battalion
cd $SCRIPT_DIRECTORY

git clone https://github.com/ChrisTruncer/EyeWitness $SCRIPT_DIRECTORY/tools/EyeWitness
cd $SCRIPT_DIRECTORY/tools/EyeWitness
git checkout tags/2.2.2 -b battalion
cd $SCRIPT_DIRECTORY

git clone https://github.com/laramies/theHarvester $SCRIPT_DIRECTORY/tools/theHarvester
cd $SCRIPT_DIRECTORY/tools/theHarvester
git checkout tags/2.7 -b battalion
cd $SCRIPT_DIRECTORY

git clone https://github.com/urbanadventurer/WhatWeb $SCRIPT_DIRECTORY/tools/WhatWeb

git clone https://github.com/wpscanteam/wpscan $SCRIPT_DIRECTORY/tools/wpscan
cd $SCRIPT_DIRECTORY/tools/wpscan
git checkout tags/2.9.2 -b battalion
cd $SCRIPT_DIRECTORY

git clone https://github.com/elceef/dnstwist $SCRIPT_DIRECTORY/tools/dnstwist
cd $SCRIPT_DIRECTORY/tools/dnstwist
git checkout tags/v1.02 -b battalion
cd $SCRIPT_DIRECTORY
