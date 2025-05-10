#!/bin/bash

# Script to install and configure dnscrypt-proxy
# This script configures dnscrypt-proxy to work with Pi-hole using only the best
# DNSCrypt, DNS-over-HTTPS and No-Log servers with DNSSEC validation
# This script must be run with root privileges

# Define colors
GREEN='\033[0;32m'
LIGHT_BLUE='\033[94m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear

# Print banner
echo -e "${LIGHT_BLUE}"
echo -e "╔════════════════════════════════════════════════╗"
echo -e "║                                                ║"
echo -e "║  ${CYAN}DNSCrypt-Proxy Setup for Pi-hole${LIGHT_BLUE}              ║"
echo -e "║  ${CYAN}Secure DNS with DNSCrypt, DoH, and DNSSEC${LIGHT_BLUE}     ║"
echo -e "║                                                ║"
echo -e "╚════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
	echo -e "${RED}[ERROR]${NC} This script must be run as root."
	echo -e
	exit 1
fi

# Variable for the package name
PACKAGE_NAME="dnscrypt-proxy"

# Function to check if a package is installed
is_installed() {
	dpkg -s "$1" > /dev/null 2>&1
	return $?
}

# Check if the package is already installed
if is_installed "$PACKAGE_NAME"; then
	echo -e "${GREEN}[INFO]${NC} $PACKAGE_NAME is already installed. Proceeding with the script..."
else
	# Check if the package exists in the repository and attempt installation
	if apt update && apt install -y "$PACKAGE_NAME"; then
		echo -e "${LIGHT_BLUE}[INFO]${NC} $PACKAGE_NAME installed successfully. Proceeding with the script..."
	else
		echo -e
		echo -e "${RED}[ERROR]${NC} The requested Debian package isn't available in the repositories."
		echo -e
		exit 1
	fi
fi

# Backup the original configuration file if backup doesn't already exist
if [ -f /etc/dnscrypt-proxy/dnscrypt-proxy.toml ]; then
	if [ ! -f /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak ]; then
		cp /etc/dnscrypt-proxy/dnscrypt-proxy.toml /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak
		echo -e "${GREEN}[OK]${NC} Backup of the original configuration file created in /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak"
	else
		echo -e "${YELLOW}[INFO]${NC} Backup file /etc/dnscrypt-proxy/dnscrypt-proxy.toml.bak already exists, preserving it"
	fi
fi

# Create the new configuration file
echo -e "${YELLOW}[STEP]${NC} Creating configuration file..."
cat > /etc/dnscrypt-proxy/dnscrypt-proxy.toml << 'EOL'
##########################################
#        GLOBAL SETTINGS                 #
##########################################

# Server addresses and networking
listen_addresses = ['127.0.0.1:53533']
bootstrap_resolvers = [
    "1.1.1.1:53",
    "8.8.8.8:53",
    "9.9.9.9:53",
]
ignore_system_dns = true
max_clients = 250

# Protocol settings
force_tcp = false
ipv4_servers = true
ipv6_servers = false
dnscrypt_servers = true
doh_servers = true
odoh_servers = false

# Security requirements
require_dnssec = true
require_nolog = true
require_nofilter = true


##########################################
#        DNS CACHE                       #
##########################################

cache = true
cache_size = 10000
cache_min_ttl = 86400
cache_max_ttl = 345600
cache_neg_min_ttl = 900
cache_neg_max_ttl = 3600


##########################################
#        LOGS                            #
##########################################

log_files_max_size = 20
log_files_max_age = 10

[query_log]
file = '/var/log/dnscrypt-proxy/query.log'

[nx_log]
file = '/var/log/dnscrypt-proxy/nx.log'


##########################################
#        PUBLIC RESOLVERS AND RELAYS     #
##########################################

[sources.public-resolvers]
urls = [
	'https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md',
	'https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md'
]
cache_file = '/var/cache/dnscrypt-proxy/public-resolvers.md'
minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
refresh_delay = 73
prefix = ''

[sources.relays]
urls = [
	'https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md',
	'https://download.dnscrypt.info/resolvers-list/v3/relays.md'
]
cache_file = '/var/cache/dnscrypt-proxy/relays.md'
minisign_key = 'RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3'
refresh_delay = 73
prefix = ''
EOL

echo -e "${GREEN}[OK]${NC} Configuration file created in /etc/dnscrypt-proxy/dnscrypt-proxy.toml"

# Modify the socket unit file
echo -e "${YELLOW}[STEP]${NC} Modifying socket unit file..."
if [ -f /lib/systemd/system/dnscrypt-proxy.socket ]; then
	sed -i "s#^\(ListenStream=127.0.2.1:\)[0-9]\+#\153533#g" /lib/systemd/system/dnscrypt-proxy.socket
	sed -i "s#^\(ListenDatagram=127.0.2.1:\)[0-9]\+#\153533#g" /lib/systemd/system/dnscrypt-proxy.socket
	echo -e "${GREEN}[OK]${NC} Socket unit file modified successfully"
else
	echo -e "${RED}[WARNING]${NC} Socket unit file not found at /lib/systemd/system/dnscrypt-proxy.socket"
	echo -e "${RED}[WARNING]${NC} Cannot modify the socket configuration. Please install dnscrypt-proxy first."
	exit 1
fi

# Configure correct permissions
echo -e "${YELLOW}[STEP]${NC} Setting up permissions..."
chown -R dnscrypt:dnscrypt /etc/dnscrypt-proxy 2>/dev/null || \
	chown -R _dnscrypt-proxy:_dnscrypt-proxy /etc/dnscrypt-proxy 2>/dev/null || \
	chown -R nobody:nogroup /etc/dnscrypt-proxy

# Enable and restart the socket and service
echo -e "${YELLOW}[STEP]${NC} Restarting services..."
systemctl daemon-reload
systemctl enable dnscrypt-proxy.socket
systemctl enable dnscrypt-proxy
systemctl restart dnscrypt-proxy.socket
systemctl restart dnscrypt-proxy

# Check service status
sleep 2
if systemctl is-active --quiet dnscrypt-proxy; then
	echo -e "${GREEN}[SUCCESS]${NC} dnscrypt-proxy has been successfully configured!"
	echo -e "${GREEN}[INFO]${NC} The service is running on 127.0.0.1:53533 and socket on 127.0.2.1:53533"
else
	echo -e "${RED}[ERROR]${NC} There was a problem starting dnscrypt-proxy."
	echo -e "${YELLOW}[TIP]${NC} Check the status with: systemctl status dnscrypt-proxy"
fi

# Instructions for configuring Pi-hole to use dnscrypt-proxy*
echo -e "\n${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║ Pi-hole Configuration Guide                       ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
echo -e "${YELLOW}To use dnscrypt-proxy with Pi-hole:${NC}"
echo -e "1. Go to Pi-hole admin interface ${LIGHT_BLUE}(http://pi.hole/admin)${NC}"
echo -e "2. Navigate to ${GREEN}Settings > DNS${NC}"
echo -e "3. ${RED}Disable${NC} all upstream DNS servers"
echo -e "4. Under '${GREEN}Custom DNS Servers${NC}', add: ${CYAN}127.0.0.1#53533${NC}"
echo -e "5. Save and restart DNS resolver"
echo -e "\n${CYAN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║ Verification Methods                              ║${NC}"
echo -e "${CYAN}╚═══════════════════════════════════════════════════╝${NC}"
echo -e "${YELLOW}Check DNS resolution:${NC}"
echo -e "${LIGHT_BLUE}tail -f /var/log/dnscrypt-proxy/query.log${NC}"
echo -e "\n${YELLOW}Check server with the lowest initial latency:${NC}"
echo -e "${LIGHT_BLUE}journalctl -f -u dnscrypt-proxy${NC}"
echo -e "\n${YELLOW}Test Your Browsing Security:${NC}"
echo -e "${GREEN}https://www.cloudflare.com/ssl/encrypted-sni${NC}"
echo -e "\n${LIGHT_BLUE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${LIGHT_BLUE}║ DNSCrypt-Proxy Setup Complete                     ║${NC}"
echo -e "${LIGHT_BLUE}╚═══════════════════════════════════════════════════╝${NC}"
echo -e

exit 0
