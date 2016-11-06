Battalion
=========
Battalion is a tool designed to automate a huge portion of a standard pentest. By supplying only a domain name and website site Battalion goes through the various passive and active reconaissance tasks, enumerates publicly accessible sites and services, identifies potential misconfigurations or vulnerable technologies, discoves and identifies breached accounts, build reports, and much more.

Ultimately Battalion will automate beyond reconaissance and go so far as to trigger phishing campaigns, automatically exploit some discovered vulnerabilities, and come with post-exploitation options.

Try out Battalion and send us any feedback! https://github.com/eidolonpg and I are excited to build out this tool and make it as comprehensive and efficient as possible!



# Quick Setup

Battalion depends on a number of other tools and many of these tools function from cloned Git repositories. Here is how to get started.

Manually configure these tools on your system:

- [Nmap](https://nmap.org/)
- [whois](https://github.com/weppos/whois)

The following command will prepare these tools on your system. This will not work on all systems.

```bash
apt-get install nmap
gem install whois
```

In addition to the above tools there are several more Battalion utilizes to run properly. Below are the tools which can be installed manually or with the [download-tools](download-tools.sh) script.

The following tools to be cloned:

- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [TheHarvester](https://github.com/laramies/theHarvester)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [wpscan](https://github.com/wpscanteam/wpscan)

Battalion provides a script [download-tools](download-tools.sh) to automatically clone all of the required
GitHub repositories. Additional setup is required after cloning the tools. Using this script allows Battalion to know where to look for the toolsr.

Once cloned, navigate in to each directory and install the requirements for each tool and validate the tool works. If these tools are all working, Battalion will run properly. This will typically just involve going in to each tool directory and running: `pip install -r requirements.txt`

The following is the complete list of 3rd party tools leveraged by Battalion:

- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [Nmap](https://nmap.org/)
- [TheHarvester](https://github.com/laramies/theHarvester)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [whois](https://github.com/weppos/whois)
- [wpscan](https://github.com/wpscanteam/wpscan)

## Install on Kali Linux
```
apt-get install jq
git clone https://github.com/battalion
cd battalion
./download-tools.sh
cd tools

#dnsrecon

pip install -r requirements.txt
#Currently there is an issue (11/5/2016) which prevents `./dnsrecon` from running unless -t is specified.
#Test functionality by using the following to trigger the help message
./dnsrecon -t
cd ..

#EyeWitness
cd EyeWitness/setup
./setup.sh
cd ..
#Test functionality by typing the following to trigger the help message
./EyeWitness.py
cd ..

#theHarvester
chmod +x theHarvester.py
#Test functionality by typing the following to trigger the help message
./theHarvester.py
cd ..

#WhatWeb
#This should work by default. Test functionality by typing the following to trigger the help message
./whatweb
cd ..

#wpscan
sudo apt-get install libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
cd wpscan
unzip data.zip
#Test functionality by typing the following to trigger the help message
./wpscan.rb
cd ../..

#Ruby Whois
gem install whois
```

Battalion should now be ready to run on your Kali system!


## Using your own tool installations

Battalion also supports configuring the locations of tools via environment variables:

- `BATTALION_DNSRECON_HOME`
- `BATTALION_EYEWITNESS_HOME`
- `BATTALION_HARVESTER_HOME`
- `BATTALION_WHATWEB_HOME`
- `BATTALION_WPSCAN_HOME`

# Using Battalion

## Required Parameters for All Scans

- `--name <scan name>`: The scan name
- `--out  <directory>`: The output directory (absolute path)

## Required Parameters for Domain Scans

- `--domain <domain name>`: The domain name to scan

## Required Parameters for User Scans

- `--company <company name>`: The company name per LinkedIn, used for user scraping

## Optional Parameters

- `--email-domain <domain name>`: Allows a different email domain to be configured
- `--subdomain-list <file>`: Specify a file that provides potential subdomains
- `--nmap`: Enable light touch nmap scanning of subdomains
- `--shodan <api key>`: Specify a Shodan API key and enables a Shodan scan
- `--timeout-http <seconds>`: Specify a timeout in seconds for HTTP detection
- `--timeout-eyewitness <seconds>`: Specify a timeout in seconds for EyeWitness individual scans

## Disabling Scans

- `--disable-user`: Disable the user scan
- `--disable-domain`: Disable the domain scan

# Scan Output

Battalion produces a number of directories which help categorize raw output. It also produces
a directory called `report` which will contain a Markdown report summarizing and organizing the output.
All of these directories will be created at the location specified by the `--out` parameter and do
not need to be created.

## Expected Scan Time (User)

The current scan time for the user scan is rather large -- over 20 minutes. We're currently working
on a way to improve this by changing how Battalion identifies email addresses.

## Expected Scan Time (Domain)

Scans depend very much on the 'size' of the target, where the size is deteremined by the number of
users and the number of detected domain records. Even for small targets scans will normally take a
few minutes to complete.

# Disclaimer

This utility has been created purely for the purposes of research and for improving defense, and is not intended to be used to attack systems except where explicitly authorized. Project maintainers are not responsible or liable for misuse of the software. Use responsibly.
