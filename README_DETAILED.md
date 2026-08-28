# 🛡️ DNSCrypt-Proxy for Pi-hole - Complete Guide

---

## 📖 TABLE OF CONTENTS

1. [What Is This?](#what-is-this)
2. [Before You Start](#before-you-start)
3. [How It Works](#how-it-works)
4. [Installation Methods](#installation-methods)
5. [Step-by-Step Installation](#step-by-step-installation)
6. [Configure Pi-hole](#configure-pihole)
7. [Verify Everything Works](#verify-everything-works)
8. [Troubleshooting](#troubleshooting)
9. [Common Questions](#common-questions)
10. [Security Details](#security-details)
11. [Uninstall](#uninstall)

---

## 🤔 What Is This? {#what-is-this}

### Simple Explanation

**DNS (Domain Name System)** = The service that converts domain names (like google.com) into IP addresses (like 142.250.185.46) that your computer can understand.

**Problem:** Traditional DNS queries are sent in **plain text** - anyone on your network or your ISP can see which websites you visit.

**Solution:** This package encrypts your DNS queries using **DNSCrypt** and **DNS-over-HTTPS**, so nobody can see what websites you're visiting.

### What This Package Does

```
Your Device
    ↓
[DNSCrypt-proxy] ← Encrypts DNS queries
    ↓
Secure DNS Servers (no-log, DNSSEC-validated)
    ↓
[Pi-hole] ← Blocks ads/malware
    ↓
Your Device gets response
```

### What You'll Gain

✅ **Encrypted DNS** - ISP can't see your browsing
✅ **Ad Blocking** - Combined with Pi-hole
✅ **DNSSEC** - Protection against DNS spoofing
✅ **No-Log Servers** - Selected servers that don't store your queries
✅ **Automatic Failover** - If one DNS server fails, switches to another

---

## ⚠️ Before You Start {#before-you-start}

### Prerequisites (You Must Have These)

✅ **Raspberry Pi** running:
- Raspberry Pi OS 11 (bullseye) or newer
- 64-bit (arm64) OR 32-bit (armhf)
- At least 512 MB RAM
- At least 100 MB free disk space

✅ **Pi-hole Already Installed**
```bash
# Check if Pi-hole is installed
sudo systemctl status pihole-FTL
# Should show "active (running)"
```

✅ **Internet Connection**
- Stable and working
- Can reach github.com

✅ **SSH Access** or terminal on the Pi

### Check Your Architecture

```bash
# Run this command to see your system type
dpkg --print-architecture
```

**Output:**
- `arm64` = 64-bit (newer Raspberry Pi 4/5)
- `armhf` = 32-bit (older Raspberry Pi)
- `amd64` = PC/Intel (NOT supported by this package)

### Network Port Info

⚠️ **Important:** This service will use port **53533**

You'll tell Pi-hole to use this port for DNS queries.

---

## 🔧 How It Works {#how-it-works}

### The Three Scripts Explained

#### Script 1: `dnscrypt-proxy-pihole-install` (Recommended for Beginners)

**What it does:**
1. Detects your system architecture (arm64 or armhf)
2. Downloads the correct .deb package from GitHub
3. Installs the .deb file
4. Automatically starts the service
5. Configuration already pre-set

**When to use:** If you're new to Linux - it does everything for you

```bash
# One command does it all
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole-install | bash
```

#### Script 2: `dnscrypt-proxy-pihole.bash` (For Manual Configuration)

**What it does:**
1. Checks if dnscrypt-proxy is installed
2. If NOT installed, installs it from Debian repositories
3. Backs up original configuration
4. Replaces config with Pi-hole optimized version
5. Restarts the service

**When to use:** If you already have dnscrypt-proxy and want to reconfigure it

```bash
# Run this AFTER installing dnscrypt-proxy manually
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole.bash | bash
```

#### Script 3: `install-latest-dnscrypt-proxy.bash` (For Advanced Users)

**What it does:**
1. Downloads the LATEST version from official Debian repositories
2. Installs it (not pre-configured)
3. You must configure it manually afterward

**When to use:** If you want vanilla dnscrypt-proxy (no pre-configuration)

```bash
# Advanced users only
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/install-latest-dnscrypt-proxy.bash | bash
```

### Decision Tree

```
Do you have dnscrypt-proxy already installed?
├─ NO  → Use script 1 or 3
│       ├─ Want it configured for Pi-hole automatically?
│       │  └─ YES → Script 1 (Recommended)
│       └─ Want to configure it yourself?
│          └─ YES → Script 3
│
└─ YES → Use script 2
        └─ Reconfigure for Pi-hole
```

---

## 📦 Installation Methods {#installation-methods}

### METHOD A: Quick Install (Recommended) ⭐

For most people. Installs and configures everything.

```bash
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole-install | bash
```

**What happens:**
```
1. Script detects your system (arm64 or armhf)
2. Downloads correct .deb from GitHub
3. Installs with apt
4. Service automatically starts
5. Ready to configure in Pi-hole
```

**Time:** ~2 minutes

### METHOD B: Install from Debian Repos (Latest)

For users who want the most recent official version.

```bash
# Step 1: Install from Debian repositories
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/install-latest-dnscrypt-proxy.bash | bash

# Step 2: Configure for Pi-hole
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole.bash | bash
```

**What happens:**
```
1. Downloads latest version from official Debian repos
2. Installs package
3. Second script configures it for Pi-hole
4. Service restarts with new config
```

**Time:** ~3 minutes

### METHOD C: Install from GitHub Pre-built

For maximum control. Download .deb manually.

```bash
# Download the .deb file for your architecture
# For 64-bit: dnscrypt-proxy-pihole_latest_arm64.deb
# For 32-bit: dnscrypt-proxy-pihole_latest_armhf.deb

# Then install
sudo apt install ~/dnscrypt-proxy-pihole_latest_arm64.deb

# Then run the configuration script
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole.bash | bash
```

---

## 👣 Step-by-Step Installation {#step-by-step-installation}

### For Complete Beginners

#### Step 1: Connect to Your Raspberry Pi

```bash
# SSH into your Pi (or use terminal if connected to screen/keyboard)
ssh pi@192.168.1.100  # Replace with your Pi's IP address
```

#### Step 2: Run the Installation Script

```bash
# Copy and paste this entire command
curl -sSfL https://raw.githubusercontent.com/mapi68/dnscrypt-proxy-pihole/master/dnscrypt-proxy-pihole-install | bash
```

**Expected output:**
```
[INFO] Detecting architecture...
[INFO] Downloading dnscrypt-proxy-pihole_latest_arm64.deb...
[INFO] Installing package...
[OK] Installation completed successfully
[INFO] Service is running on 127.0.0.1:53533
```

#### Step 3: Verify Installation

```bash
# Check if service is running
sudo systemctl status dnscrypt-proxy

# Expected output: "active (running)"
```

#### Step 4: Check the Logs

```bash
# View recent logs
sudo journalctl -u dnscrypt-proxy -n 20 -f

# You should see messages about servers being loaded
```

#### Step 5: Configure Pi-hole (Next Section)

See "Configure Pi-hole" below

---

## 🥧 Configure Pi-hole {#configure-pihole}

### Why This Step Matters

Pi-hole needs to know: "Hey, use DNSCrypt-proxy for DNS instead of your default setup"

### Step-by-Step Configuration

#### Step 1: Open Pi-hole Admin Interface

```
Open your browser and go to:
http://192.168.1.100/admin
(Replace 192.168.1.100 with your Pi's IP)
```

#### Step 2: Navigate to DNS Settings

```
1. Click "Settings" (top right)
2. Click "DNS" (left menu)
3. Look for "Upstream DNS Servers"
```

#### Step 3: Add DNSCrypt-proxy as Upstream DNS

```
Under "Upstream DNS Servers":
1. Check: Custom (3rd line)
2. In the input field, type: 127.0.0.1#53533
3. Click "Save"
```

#### Step 4: Disable Existing DNSSEC (Important!)

```
Because DNSCrypt-proxy handles DNSSEC:
1. Look for "DNSSEC" section
2. UNCHECK the box "Validate DNSSEC"
3. Click "Save"
```

#### Step 5: Verify Configuration

```
Your DNS settings should now show:
- Upstream DNS: 127.0.0.1#53533
- DNSSEC: Unchecked
```

### What Does Port 53533 Mean?

```
Port 53 = Standard DNS port (what your devices normally use)
Port 53533 = Special port where DNSCrypt-proxy listens
             Pi-hole queries this port, gets answers, gives to your devices on port 53
```

---

## ✅ Verify Everything Works {#verify-everything-works}

### Quick Check (2 Minutes)

#### Check 1: Service is Running

```bash
sudo systemctl status dnscrypt-proxy
```

**Should show:**
```
● dnscrypt-proxy.service - DNSCrypt proxy
   Loaded: loaded (/lib/systemd/system/dnscrypt-proxy.service; enabled)
   Active: active (running) since Mon 2026-04-15 10:30:00 BST; 5min ago
```

#### Check 2: Port is Listening

```bash
sudo netstat -tlnp | grep 53533
```

**Should show:**
```
tcp  0  0  127.0.0.1:53533  0.0.0.0:*  LISTEN  1234/dnscrypt-proxy
```

#### Check 3: Pi-hole Shows Upstream DNS

```
In Pi-hole Admin:
1. Go to Settings → DNS
2. Should see "127.0.0.1#53533" listed
3. Should see recent queries from Pi-hole
```

### Full Verification Tests

#### Test 1: DNS Resolution Works

```bash
# Test DNS resolution through dnscrypt-proxy
dig google.com @127.0.0.1 -p 53533
```

**Expected output:**
```
; <<>> DiG 9.16.27-Debian <<>> google.com @127.0.0.1 -p 53533
; (1 server found)

;; Query time: 45 msec
;; WHEN: Mon Apr 15 10:35:00 BST 2026
;; MSG SIZE  rcvd: 64

google.com.        299 IN  A    142.250.185.46
```

**What this means:** ✅ DNS is working!

#### Test 2: DNSSEC Validation (Valid Domain)

```bash
# Test a domain with valid DNSSEC signature
dig +dnssec google.com @127.0.0.1 -p 53533
```

**Expected output:**
```
;; ->>HEADER<<- opcode: QUERY, status: NOERROR
```

**What this means:** ✅ DNSSEC validation passed!

#### Test 3: DNSSEC Validation (Invalid Domain - Should Fail)

```bash
# Test a domain with bad DNSSEC signature
dig dnssec-failed.org @127.0.0.1 -p 53533
```

**Expected output:**
```
;; ->>HEADER<<- opcode: QUERY, status: SERVFAIL
```

**What this means:** ✅ DNSSEC is actively blocking bad signatures!

#### Test 4: Check Query Logs

```bash
# View live DNS queries
sudo tail -f /var/log/dnscrypt-proxy/query.log
```

**Expected output:**
```
[2026-04-15 10:35:00] google.com [A] -dnscrypt-relay-1
[2026-04-15 10:35:05] github.com [A] dnscrypt-relay-2
[2026-04-15 10:35:10] example.com [A] -dnscrypt
```

**Columns:**
- Timestamp = When query happened
- Domain = What was looked up
- Record type = A (IPv4), AAAA (IPv6), etc.
- Server = Which DNS server answered

#### Test 5: Online Verification

```
Visit these websites to verify:
1. https://www.dnsleaktest.com
   - Should NOT show your ISP's DNS servers
   - Should show the servers dnscrypt-proxy uses

2. https://www.cloudflare.com/ssl/encrypted-sni
   - Should show your DNS is encrypted
```

### What If Tests Fail?

See the **Troubleshooting** section below.

---

## 🔧 Troubleshooting {#troubleshooting}

### Problem 1: Service Won't Start

**Symptom:**
```bash
sudo systemctl status dnscrypt-proxy
# Shows: "inactive (dead)"
```

**Solution:**

```bash
# Step 1: Check the error message
sudo journalctl -u dnscrypt-proxy -n 50

# Look for error messages in output

# Step 2: Check if port 53533 is available
sudo netstat -tlnp | grep 53533
# If shows something, another app is using it

# Step 3: Restart the service
sudo systemctl restart dnscrypt-proxy

# Step 4: Check status again
sudo systemctl status dnscrypt-proxy
```

### Problem 2: DNS Doesn't Resolve

**Symptom:**
```bash
dig google.com @127.0.0.1 -p 53533
# Returns: connection refused
```

**Solution:**

```bash
# Step 1: Check if dnscrypt-proxy is listening
sudo netstat -tlnp | grep dnscrypt

# Should show something like:
# tcp 0 0 127.0.0.1:53533

# Step 2: If not listening, check configuration
cat /etc/dnscrypt-proxy/dnscrypt-proxy.toml | grep listen_addresses

# Should show:
# listen_addresses = ['127.0.0.1:53533']

# Step 3: If wrong, restore backup and reconfigure
sudo cp /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak \
        /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Step 4: Restart
sudo systemctl restart dnscrypt-proxy
```

### Problem 3: Pi-hole Not Using DNSCrypt

**Symptom:**
```
In Pi-hole, DNS queries still go to default servers
```

**Solution:**

```bash
# Step 1: Check Pi-hole settings via web interface
# Go to Settings → DNS
# Verify "127.0.0.1#53533" is listed

# Step 2: Restart Pi-hole
sudo systemctl restart pihole-FTL

# Step 3: Check if queries reach dnscrypt-proxy
sudo tail -f /var/log/dnscrypt-proxy/query.log
# Should see domains being queried

# Step 4: If not working, restart both services
sudo systemctl restart dnscrypt-proxy pihole-FTL
```

### Problem 4: Slow DNS Resolution

**Symptom:**
```
Websites load slowly, DNS is slow
```

**Solution:**

```bash
# Step 1: Check CPU/Memory usage
top
# Is dnscrypt-proxy using lots of CPU?

# Step 2: Check logs for errors
sudo journalctl -u dnscrypt-proxy -n 100 | grep -i error

# Step 3: If no servers available
# This means all DNSCrypt servers are down (unlikely)
# Try temporarily using different bootstrap resolvers:

sudo nano /etc/dnscrypt-proxy/dnscrypt-proxy.toml
# Find: bootstrap_resolvers = ...
# Change to:
# bootstrap_resolvers = ['1.1.1.1:53', '8.8.8.8:53', '9.9.9.9:53']

# Step 4: Restart
sudo systemctl restart dnscrypt-proxy
```

### Problem 5: Can't Access Pi-hole Admin

**Symptom:**
```
Can't open http://192.168.1.100/admin
```

**Solution:**

```bash
# Step 1: Check Pi-hole is running
sudo systemctl status pihole-FTL

# Step 2: Check if web service is running
sudo systemctl status lighttpd

# Step 3: Check your IP address is correct
hostname -I
# Use this IP in browser instead

# Step 4: Check firewall
sudo ufw status
# May need to allow port 80 if using UFW

# Step 5: Restart everything
sudo systemctl restart pihole-FTL lighttpd
```

---

## ❓ Common Questions {#common-questions}

### Q1: Will this break my internet?

**A:** No. If something goes wrong, you can always uninstall and go back to normal DNS in <5 minutes. See "Uninstall" section.

### Q2: What's the difference between DNSCrypt and DNS-over-HTTPS?

**A:** Two ways to encrypt DNS:
- **DNSCrypt** = Older, faster, works with more servers
- **DNS-over-HTTPS (DoH)** = Newer, uses HTTPS protocol, very secure
- This setup uses BOTH for maximum compatibility

### Q3: Will it slow down my internet?

**A:** Slightly, but you won't notice it:
- DNSCrypt adds ~50-100ms typically
- But Pi-hole's caching reduces queries overall
- With cached results: faster than before

### Q4: How do I know it's working?

**A:** Three signs:
1. Port 53533 shows up in: `sudo netstat -tlnp | grep 53533`
2. Queries show up in logs: `sudo tail -f /var/log/dnscrypt-proxy/query.log`
3. Your ISP can't see your DNS queries (check dnsleaktest.com)

### Q5: Does it work with other DNS services?

**A:** Only Pi-hole is officially supported. Other services might work but not guaranteed.

### Q6: What if I want to go back to normal DNS?

**A:** Just uninstall (2 commands, see Uninstall section) and set Pi-hole back to default DNS. Takes <5 minutes.

### Q7: Can I use this on other devices?

**A:** This is pre-configured for Raspberry Pi + Pi-hole. Other devices need manual setup.

### Q8: Is my data private?

**A:** Yes:
- DNSCrypt encrypts queries so ISP can't see them
- No-log servers don't store your queries
- DNSSEC prevents DNS spoofing
- But you're trusting the DNS servers you use

### Q9: Which DNS servers does it use?

**A:** It automatically selects from servers that have:
- ✅ DNSCrypt or DNS-over-HTTPS support
- ✅ No-logging policy (they promise not to store data)
- ✅ DNSSEC validation enabled
- ✅ Good uptime/speed

The configuration file has a list of ~300+ servers to choose from.

### Q10: Do I need to configure anything after installation?

**A:** Just tell Pi-hole to use port 53533. That's it. Everything else is pre-configured optimally.

---

## 🔐 Security Details {#security-details}

### What Gets Encrypted

✅ **Encrypted:**
- DNS queries (which domains you visit)
- DNS responses (IP addresses returned)
- Connection between you and DNS server

❌ **NOT Encrypted:**
- Actual web traffic (use HTTPS for that)
- DNS server can still see queries (choose no-log servers)

### DNSSEC Explained

**DNSSEC = DNS Security Extensions**

It prevents someone from:
1. Spoofing DNS responses (faking IP addresses)
2. Hijacking your requests (man-in-the-middle attacks)

**How it works:**
```
Your query → DNS server signs response with encryption key
          → Your device verifies the signature
          → If valid, you trust the answer
          → If invalid, query is rejected
```

### Privacy Considerations

**With this setup:**
- ✅ ISP can't see which websites you visit
- ✅ ISP can't see DNS queries
- ✅ Ad servers can't see your queries
- ⚠️ DNSCrypt server CAN see queries (choose no-log ones)
- ⚠️ If you trust DNSCrypt provider (this setup uses trusted ones)

**Without this setup (traditional DNS):**
- ❌ ISP sees every website
- ❌ Could sell your browsing data
- ❌ Ad networks can track you
- ❌ Routers could be hacked to redirect DNS

---

## 🗑️ Uninstall {#uninstall}

### Complete Removal

```bash
# Remove the package and all configuration
sudo apt --purge autoremove dnscrypt-proxy-pihole -y
```

### Reset Pi-hole to Default DNS

```
1. Open Pi-hole admin interface
2. Go to Settings → DNS
3. In "Upstream DNS Servers", enable any standard server:
   - 1.1.1.1 (Cloudflare)
   - 8.8.8.8 (Google)
   - Or any other you prefer
4. Click "Save"
```

### Verify It's Removed

```bash
# Should show command not found or similar
sudo systemctl status dnscrypt-proxy

# Port 53533 should be gone
sudo netstat -tlnp | grep 53533
```

---

## 📋 Quick Reference

### Essential Commands

```bash
# Check status
sudo systemctl status dnscrypt-proxy

# View logs
sudo journalctl -u dnscrypt-proxy -f

# Restart service
sudo systemctl restart dnscrypt-proxy

# View configuration
cat /etc/dnscrypt-proxy/dnscrypt-proxy.toml

# Test DNS
dig google.com @127.0.0.1 -p 53533

# View live queries
sudo tail -f /var/log/dnscrypt-proxy/query.log

# Uninstall
sudo apt --purge autoremove dnscrypt-proxy-pihole -y
```

### Important Files

```
Configuration:  /etc/dnscrypt-proxy/dnscrypt-proxy.toml
Backup:        /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak
Logs:          /var/log/dnscrypt-proxy/query.log
Service:       /lib/systemd/system/dnscrypt-proxy.service
```

### Ports

```
53533 = DNSCrypt-proxy listens here
53    = Pi-hole listens here (standard DNS)
```

---

## 🎯 Summary

### What You've Done

1. ✅ Encrypted your DNS queries
2. ✅ Protected against DNS spoofing (DNSSEC)
3. ✅ Hidden your browsing from ISP
4. ✅ Combined with Pi-hole for ad blocking
5. ✅ Set up automatic server failover

### What Happens Now

- Every time your device looks up a domain:
  1. Request goes to Pi-hole
  2. Pi-hole sends to DNSCrypt-proxy on port 53533
  3. DNSCrypt encrypts the query
  4. Sends to one of 300+ secure DNS servers
  5. Encrypted response comes back
  6. Pi-hole gives to your device

### Maintenance

- ✅ Service auto-starts on reboot
- ✅ Logs rotate automatically
- ✅ No configuration needed going forward
- ✅ Updates available via apt

### Support

- Check logs first: `sudo journalctl -u dnscrypt-proxy -f`
- Verify with: `dig google.com @127.0.0.1 -p 53533`
- Test online: https://www.dnsleaktest.com

---
