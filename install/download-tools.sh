#!/bin/bash

BASE_DIRECTORY=$1

mkdir -p $BASE_DIRECTORY/tools || true >/dev/null 2>&1

git clone https://github.com/darkoperator/dnsrecon $BASE_DIRECTORY/tools/dnsrecon
cd $BASE_DIRECTORY/tools/dnsrecon
git checkout tags/v0.8.9 -b battalion
cd $BASE_DIRECTORY

git clone https://github.com/ChrisTruncer/EyeWitness $BASE_DIRECTORY/tools/EyeWitness
cd $BASE_DIRECTORY/tools/EyeWitness
git checkout tags/2.2.2 -b battalion
cd $BASE_DIRECTORY

git clone https://github.com/laramies/theHarvester $BASE_DIRECTORY/tools/theHarvester
cd $BASE_DIRECTORY/tools/theHarvester
git checkout tags/2.7 -b battalion
cd $BASE_DIRECTORY

git clone https://github.com/urbanadventurer/WhatWeb $BASE_DIRECTORY/tools/WhatWeb

git clone https://github.com/wpscanteam/wpscan $BASE_DIRECTORY/tools/wpscan
cd $BASE_DIRECTORY/tools/wpscan
git checkout tags/2.9.2 -b battalion
cd $BASE_DIRECTORY

git clone https://github.com/elceef/dnstwist $BASE_DIRECTORY/tools/dnstwist
cd $BASE_DIRECTORY/tools/dnstwist
git checkout tags/v1.02 -b battalion
cd $BASE_DIRECTORY
