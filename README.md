Battalion
=========

# Quick Setup

Battalion depends on a number of other tools and many of these tools function from cloned Git repositories.

The following tools are leveraged by Battalion:

- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [Nmap](https://nmap.org/)
- [TheHarvester](https://github.com/laramies/theHarvester)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [whois](https://github.com/weppos/whois)
- [wpscan](https://github.com/wpscanteam/wpscan)

These should be installed manually:

- [Nmap](https://nmap.org/)
- [whois](https://github.com/weppos/whois)

These need to be cloned:

- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [TheHarvester](https://github.com/laramies/theHarvester)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [wpscan](https://github.com/wpscanteam/wpscan)

## Installed Dependencies

```bash
apt-get install nmap
gem install whois
```

## GitHub Dependencies

Battalion provides a script [download-tools](download-tools.sh) to automatically clone all of the required
GitHub repositories. Additional setup may be required. By default Battalion knows where to look for tools cloned
in this manner.

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

## Expected Scan Time

Scans depend very much on the 'size' of the target, where the size is deteremined by the number of
users and the number of detected domain records. Even for small targets scans will normally take a
few minutes to complete.

# Disclaimer

This utility has been created purely for the purposes of research and for improving defense, and is not intended to be used to attack systems except where explicitly authorized. Project maintainers are not responsible or liable for misuse of the software. Use responsibly.
