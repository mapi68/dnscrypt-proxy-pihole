# dnscrypt-proxy-pihole

* [Overview](#overview)
* [Install](#install)
* [Uninstall](#uninstall)
* [Configuration](#configuration)
* [Check](#check)

## Overview
**Preconfigured deb package for every Raspberry Pi and Pi-hole, optimized for Raspberry Pi OS 11 (bullseye) and 12 (bookworm) armhf (32bit). Elevate your experience with top-tier DNSCrypt, DNS-over-HTTPS, and No-Log servers, all seamlessly integrated for your security**

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
tail -f /var/log/dnscrypt-proxy/query.log
```
Check server with the lowest initial latency:
```bash
journalctl -u dnscrypt-proxy
```


![dnssec](images/dnssec.png)

[Browsing Experience Security Check](https://www.cloudflare.com/ssl/encrypted-sni)
