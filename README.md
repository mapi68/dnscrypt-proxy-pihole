# dnscrypt-proxy-pihole

* [Overview](#overview)
* [Installation](#installation)
* [Configuration](#configuration)

## Overview
<b>Preconfigured deb for every Raspberry Pi and Pi-hole to use encrypted Cloudflare DNS</b><br>
You have these options:
1) Standard DNS 1.1.1.1 / 1.0.0.1 (best choice)
2) DNS with malware blocking 1.1.1.2 / 1.0.0.2
3) DNS with malware protection and parental control 1.1.1.3 / 1.0.0.3
<br><br>

## Installation
```bash
wget https://github.com/mapi68/dnscrypt-proxy-pihole/raw/master/dnscrypt-proxy-pihole_2.0.44_armhf.deb
sudo dpkg -i dnscrypt-proxy-pihole_2.0.44_armhf.deb; sudo apt install -f -y
```

To change DNS server:
```bash
sudo dpkg-reconfigure dnscrypt-proxy-pihole
```


## Configuration
<img src="https://i.postimg.cc/rpPLBkkX/cloudflare.png"><br>
<img src="https://i.postimg.cc/ZqTsHhnG/pihole1.png"><br>
<img src="https://i.postimg.cc/CKmP66fz/pihole2.png"><br><br>

Check if everything is fine here: https://www.cloudflare.com/ssl/encrypted-sni/
<img src="https://i.postimg.cc/zvQ2xzZ3/check.png"><br>
