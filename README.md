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

