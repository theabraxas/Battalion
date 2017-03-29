#!/bin/sh

sudo apt-get install jq nmap libgeoip-dev libffi-dev libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev build-essential libgmp-dev zlib1g-dev curl

pip install requests

cd tools/dnsrecon
pip install -r requirements.txt

cd ../dnstwist
pip install GeoIP==1.3.2 dnspython==1.14.0 requests==2.11.1 whois==0.7

cd ../EyeWitness
sudo -H ./setup/setup.sh

gem install json
gem install whois

cd ../wpscan
gem install bundler
bundle install --without test
