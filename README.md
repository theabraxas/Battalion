Battalion
=========
Battalion is a tool designed to automate a huge portion of a standard pentest. By supplying only a domain name and website site Battalion goes through the various passive and active reconaissance tasks, enumerates publicly accessible sites and services, identifies potential misconfigurations or vulnerable technologies, discoves and identifies breached accounts, build reports, and much more.

Ultimately Battalion will automate beyond reconaissance and go so far as to trigger phishing campaigns, automatically exploit some discovered vulnerabilities, and come with post-exploitation options.

Try out Battalion and send us any feedback! https://github.com/eidolonpg and I are excited to build out this tool and make it as comprehensive and efficient as possible!

# Installation

Battalion depends on a number of tools - please see the primary documentation in the [Battalion Installation Guide](INSTALL.md) for more information. This distribution also includes scripts for some system types in the `install` directory. The installation documentation provides more information on these scripts.

# Using Battalion

## Example: Scanning a Domain and Users

```bash
$ ./battalion.sh --name "Test Scan" --out /home/user/scans/company \
    --company "My Company" --domain "company.com" --nmap
```

This scan for `My Company` will produce results in the directory `/home/user/scans/company`. The domain scan would be based on the specified domain `company.com`, whereas the user scan is based upon the company name `My Company`. This scan also enables a light Nmap scan on the detected domains.

## Required Parameters for All Scans

- `--name <scan name>`: The scan name
- `--out  <directory>`: The output directory (absolute path)

## Required Parameters for Domain Scans

- `--domain <domain name>`: The domain name to scan

## Required Parameters for User Scans

- `--company <company name>`: The company name per LinkedIn, used for user scraping

## Optional Parameters

- `--email-domain <domain name>`: Allows a different email domain to be configured. Use this if the primary domain is `x.com` but users receive mail at `y.com` addresses.
- `--subdomain-list <file>`: Specify a file that provides potential subdomains, this is used by the dnsrecon tool. That tool provides some high-quality default lists.
- `--nmap`: Enable light touch nmap scanning of subdomains
- `--nmap-aggressive`: (Long running!) This is a VERY intense scan on each subdomain, approximately 10 minutes per subdomain.
- `--shodan <api key>`: Specify a Shodan API key and enables a Shodan scan
- `--hunter <api key>`: Sets a Hunter.io API Key and enables Hunter in the user scan. This will vastly speed up the user scan!
- `--timeout-http <seconds>`: Specify a timeout in seconds for HTTP detection
- `--timeout-eyewitness <seconds>`: Specify a timeout in seconds for EyeWitness individual scans

## Disabling Major Scan Types

- `--disable-user`: Disable the user scan
- `--disable-domain`: Disable the domain scan

# Scan Output

Battalion produces a number of directories which help categorize raw output. All of these directories will be created at the location specified by the `--out` parameter by the Battalion script.

## Expected Scan Time (User)

The current default scan time for the user scan is rather large -- over 20 minutes. We recomment acquiring a [Hunter](https://hunter.io) API key to expidite this process.

## Expected Scan Time (Domain)

Scans depend very much on the 'size' of the target, where the size is deteremined by the number of users and the number of detected domain records. Small targets usually take at least a few minutes to complete.

# Disclaimer

This utility has been created purely for the purposes of research and for improving defense, and is not intended to be used to attack systems except where explicitly authorized. Project maintainers are not responsible or liable for misuse of the software. Use responsibly.
