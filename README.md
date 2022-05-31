# dnscrypt-proxy-pihole

* [Overview](#overview)
* [Install](#install)
* [Uninstall](#uninstall)
* [Configuration](#configuration)

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
![configure](images/configure.png)

After installation you can reconfigure dnscrypt-proxy-pihole with:
```bash
sudo dpkg-reconfigure dnscrypt-proxy-pihole
```

![pihole port](images/pihole1.png)
![pihole advanced dns settings](images/pihole3.png)
![dnssec](images/dnssec.png)

[DNSSEC Resolver Test](https://dnssec.vs.uni-due.de)
