# dnscrypt-proxy-pihole

* [Overview](#overview)
* [Install](#install)
* [Uninstall](#uninstall)
* [Configuration](#configuration)
* [Check](#check)

## Overview
**Preconfigured deb package for every Raspberry Pi and Pi-hole to use only best DNSCrypt, DNS-over-HTTPS and No-Log servers.**

## Install
```bash
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole-install | bash
```
## Uninstall
```bash
sudo apt --purge remove dnscrypt-proxy-pihole -y
```


## Configuration
![pihole port](images/pihole1.png)
![pihole advanced dns settings](images/pihole3.png)


## Check
Check if dnscrypt-proxy-pihole works and resolves DNS names:
```bash
clear && tail -f -n 10 /var/log/dnscrypt-proxy/query.log
```


![dnssec](images/dnssec.png)

[DNSSEC Resolver Test](https://dnssec.vs.uni-due.de)
