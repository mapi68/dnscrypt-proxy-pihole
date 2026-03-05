<p align="center">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License: MIT"/>
  <img src="https://img.shields.io/badge/Pi--hole-Compatible-green.svg" alt="Pi-hole Compatible"/>
  <img src="https://img.shields.io/badge/Raspberry%20Pi-OS%2011%7C12%7C13-red.svg" alt="Raspberry Pi"/>
</p>

<h1 align="center">🛡️ dnscrypt-proxy-pihole</h1>

<p align="center">
  <strong>Secure DNS solution for your Raspberry Pi &amp; Pi-hole setup.</strong><br/>
  Enhanced DNS encryption and privacy with pre-configured settings.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Enhanced%20Security-DNSCrypt-brightgreen" alt="DNSCrypt"/>
  <img src="https://img.shields.io/badge/Supports-DNS--over--HTTPS-orange" alt="DoH"/>
  <img src="https://img.shields.io/badge/Privacy-No--Logs-blueviolet" alt="No Logs"/>
</p>

<p align="center">
  <a href="#overview">Overview</a> •
  <a href="#features">Features</a> •
  <a href="#install">Install</a> •
  <a href="#scripts">Scripts</a> •
  <a href="#configuration">Configuration</a> •
  <a href="#verification">Verification</a> •
  <a href="#uninstall">Uninstall</a>
</p>

<p align="center">
  <a href="https://ko-fi.com/mapi68">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Support on Ko-fi"/>
  </a>
</p>

---

## 🔍 Overview <a name="overview"></a>

A preconfigured **DNSCrypt-proxy** package for Raspberry Pi and Pi-hole users that ensures secure, encrypted DNS queries through carefully selected DNSCrypt and DNS-over-HTTPS servers with strict no-logging policies.

### 📦 Compatibility

✅ **Current Version:**
- [Raspberry Pi OS 64bit arm64](https://github.com/mapi68/dnscrypt-proxy-pihole/raw/refs/heads/master/dnscrypt-proxy-pihole_latest_arm64.deb)
- [Raspberry Pi OS 32bit armhf](https://github.com/mapi68/dnscrypt-proxy-pihole/raw/refs/heads/master/dnscrypt-proxy-pihole_latest_armhf.deb)
- Pi-hole v6.0+
- DNS server: `127.0.0.1#53533`

⚠️ **Legacy Version:**
- [Raspberry Pi OS 11 (bullseye)](https://github.com/mapi68/dnscrypt-proxy-pihole/raw/refs/heads/master/dnscrypt-proxy-pihole_bullseye_armhf.deb)

---

## ✨ Features <a name="features"></a>

| Feature | Description | Benefit |
|---|---|---|
| 🔒 **DNSCrypt** | Advanced DNS encryption | Protects against DNS surveillance |
| 🌐 **DNS-over-HTTPS** | Modern DNS protocol support | Additional security layer |
| 🕵️ **Privacy Focus** | No-log DNS servers only | Ensures query privacy |
| 🛡️ **DNSSEC** | Built-in validation | Prevents DNS spoofing |
| ⚡ **Optimized** | Raspberry Pi tuned | Efficient resource usage |

---

## 🚀 Install <a name="install"></a>

Install with a single command:

```bash
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole-install | bash
```

---

## 📜 Scripts <a name="scripts"></a>

### 1. `install-latest-dnscrypt-proxy.bash`

Downloads and installs the latest dnscrypt-proxy package directly from official Debian repositories.

- Auto-detects system architecture
- Downloads latest version from Debian repos
- Handles all dependencies
- Multi-architecture support (amd64, arm64, armhf, ...)

```bash
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/refs/heads/master/install-latest-dnscrypt-proxy.bash | bash
```

### 2. `dnscrypt-proxy-pihole.bash`

Sets up DNSCrypt-proxy for optimal use with Pi-hole.

- Configures secure DNS settings
- Sets up port 53533 for Pi-hole
- Enables DNSSEC validation
- Configures no-logging policy
- Optimizes caching

```bash
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/refs/heads/master/dnscrypt-proxy-pihole.bash | bash
```

### Installation Methods

| Method | Description | When to Use |
|---|---|---|
| `dnscrypt-proxy-pihole-install` | Installs pre-configured package | Quick, automated setup |
| `install-latest-dnscrypt-proxy.bash` | Installs vanilla dnscrypt-proxy from Debian repos | Custom installations |
| `dnscrypt-proxy-pihole.bash` | Configures dnscrypt-proxy for Pi-hole | After manual installation |

---

## ⚙️ Configuration <a name="configuration"></a>

### Pi-hole Setup

1. Access the Pi-hole admin interface
2. Navigate to **Settings → DNS**
3. Set **Custom DNS**: `127.0.0.1#53533`
4. Disable DNSSEC (handled by DNSCrypt)

![Pi-hole DNS Configuration](images/pihole1.png)

### Important Files

| File | Purpose |
|---|---|
| `/etc/dnscrypt-proxy/dnscrypt-proxy.toml` | Main configuration |
| `/var/log/dnscrypt-proxy/query.log` | Query log |
| `/lib/systemd/system/dnscrypt-proxy.service` | Systemd service |

---

## 🔐 Verification <a name="verification"></a>

### Monitor DNS Resolution
```bash
tail -f /var/log/dnscrypt-proxy/query.log
```

### Check Service Status
```bash
journalctl -f -u dnscrypt-proxy
```

### DNSSEC Validation Tests

**Test 1 — Valid domain (should succeed):**
```bash
dig +dnssec google.com @127.0.0.1 -p 53533
```
> Expected: `status: NOERROR` — confirms connectivity and successful resolution.

**Test 2 — Corrupt signature (should fail):**
```bash
dig dnssec-failed.org @127.0.0.1 -p 53533
```
> Expected: `status: SERVFAIL` — confirms active DNSSEC validation is blocking the corrupt signature.

### Online Tests
- [DNSLeakTest](https://www.dnsleaktest.com)
- [Cloudflare ESNI Check](https://www.cloudflare.com/ssl/encrypted-sni)

![Successful Cloudflare DNSSEC Validation](images/dnssec.png)

---

## 🗑️ Uninstall <a name="uninstall"></a>

Remove completely with:
```bash
sudo apt --purge autoremove dnscrypt-proxy-pihole -y
```

---

## 📄 License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## ☕ Support

If you find this project useful, consider supporting the development:

<p align="center">
  <a href="https://ko-fi.com/mapi68">
    <img src="https://ko-fi.com/img/githubbutton_sm.svg" alt="Support on Ko-fi"/>
  </a>
</p>

---

<p align="center">
  Made with ❤️ for the Raspberry Pi community
</p>
