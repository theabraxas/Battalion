Battalion Dependency Installation Guide
=======================================

This guide is intended to detail the required tools and steps to install all of the
tools and dependencies required by Battalion.

# Target Operating Systems

This guide is currently targeted towards Ubuntu-based Linux distributions. The general steps are the same though specific instructions may vary. Please see the scripts located within the `install` directory for per-distribution steps.

# About the Installation Scripts

The provided installation scripts consolidate the procedure outlined here. These scripts assume that the current user has `sudo` access and starts within the desired directory. Please keep in mind that _dependency installation requires sudo access_. We recommend reading the script for your distribution along with any tool-provided scripts so you understand what you're executing.

## What do the scripts _not_ provide?

These scripts assume you will setup and manage your own Ruby and Python versions, and as such do not automatically install these packages.

## Automatic Installation Script

```bash
$ git clone https://github.com/theabraxas/Battalion.git
$ apt install gem
$ cd Battalion
$ ./install-dependencies <target>
```

## Supported Distributions

- [Ubuntu](install/install-ubuntu.sh): `./install-dependencies ubuntu`
- [Kali 2016.2](install/install-kali-2016-2.sh): `./install-dependencies kali-2016-2`

# Scanning Tools

Battalion leverages the following tools:

- [dnsrecon](https://github.com/darkoperator/dnsrecon)
- [EyeWitness](https://github.com/ChrisTruncer/EyeWitness)
- [Nmap](https://nmap.org/)
- [curl](https://curl.haxx.se/)
- [TheHarvester](https://github.com/laramies/theHarvester)
- [WhatWeb](https://github.com/urbanadventurer/WhatWeb)
- [whois](https://github.com/weppos/whois)
- [wpscan](https://github.com/wpscanteam/wpscan)
- [dnstwist](https://github.com/elceef/dnstwist)

# Manual Installation Steps

## Clone Battalion and Clone Tools

The [download-tools.sh](download-tools.sh) script provided by Battalion will clone all of the required tools from GitHub and check out the appropriate tagged version.

```bash
$ git clone https://github.com/theabraxas/Battalion.git
$ cd Battalion
$ ./download-tools.sh
```

## Install Tools from Package

These tools are available via the system package manager and do not require manual installation.

```bash
$ sudo apt-get install jq nmap curl
```

## Install RVM and Install Ruby Version

### Kali Linux

Kali comes with Python 2.7 and Ruby 2.3.1 by default in the 2016.2 version and does not require any additional setup. Other versions of Kali may need additional Ruby/Python setup.

### Other Installs

We recommend using RVM to manage your Ruby versions and dependencies. Please see [RVM Installation Guide](https://rvm.io/rvm/install) for instructions on installing RVM. The tools we are utilizing prefer Ruby 2.3.1:

```bash
$ rvm install 2.3.1
```

Either set version 2.3.1 as the default, or run the following before utilizing Battalion:

```bash
$ rvm use 2.3.1
```

## Install Python 2.7 

### Kali Linux

Kali comes with Python 2.7 and Ruby 2.3.1 by default in the 2016.2 version and does not require any additional setup. Other versions of Kali may need additional Ruby/Python setup.

### Other Installs

```bash
$ sudo apt-get install python2.7 python-pip
$ sudo pip install --upgrade pip
```

## Setup Tools from GitHub

### dnsrecon

```bash
$ cd tools/dnsrecon
$ pip install -r requirements.txt
```

### dnstwist

Note that some system-level dependencies are required. We currently ignore the `ssdeep` dependency since Battalion does not use it.

```bash
$ cd tools/dnstwist
$ sudo apt-get install libgeoip-dev libffi-dev
$ pip install GeoIP==1.3.2 dnspython==1.14.0 requests=2.11.1 whois==0.7
```

### EyeWitness

EyeWitness provides a setup script that installs a number of dependencies. The Battalion installation scripts utilize this setup script, which requires `sudo`. Please read through this script if you have any concerns.

```bash
$ cd tools/EyeWitness
$ sudo ./setup/setup.sh
```

### theHarvester

```bash
$ pip install requests
```

### WhatWeb

```bash
$ gem install json
```

### wpscan

```bash
$ cd tools/wpscan
$ sudo apt-get install libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev build-essential libgmp-dev zlib1g-dev
$ gem install bundler
$ bundle install --without test
```

### whois

```bash
$ gem install whois
```
