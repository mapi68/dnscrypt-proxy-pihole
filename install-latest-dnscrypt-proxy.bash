#!/bin/bash

# To use this script:
# install-latest-dnscrypt-proxy.bash    # Automatically detects architecture

# Define colors
GREEN='\033[0;32m'
LIGHT_BLUE='\033[94m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

install_latest_dnscrypt_proxy() {
	echo

    # Automatically detect architecture
    local detected_arch=$(dpkg --print-architecture 2>/dev/null)

    # If architecture detection with dpkg fails, try with uname
    if [ -z "$detected_arch" ]; then
        local machine=$(uname -m)
        case "$machine" in
            x86_64)
                detected_arch="amd64"
                ;;
            aarch64|arm64)
                detected_arch="arm64"
                ;;
            armv7l|armhf)
                detected_arch="armhf"
                ;;
            i?86)
                detected_arch="i386"
                ;;
            *)
                echo -e "${RED}[ERROR]${NC} Unrecognized architecture: $machine"
                echo -e "${YELLOW}[INFO]${NC} Please specify architecture manually as a parameter"
                exit 1
                ;;
        esac
    fi

    # Use the architecture specified as parameter or the detected one
    local arch="${1:-$detected_arch}"

    echo -e "${CYAN}[INFO]${NC} Looking for the latest dnscrypt-proxy package for architecture: ${YELLOW}$arch${NC}"

    # Repository URL
    local repo_url="http://ftp.debian.org/debian/pool/main/d/dnscrypt-proxy/"

    # Download HTML page and filter only dnscrypt-proxy files for the specified architecture
    # Sort by version (using sort -V) and take the latest
    local latest_file=$(curl -s "$repo_url" |
                        grep -o "href=\"dnscrypt-proxy_[^\"]*_${arch}\.deb\"" |
                        sed 's/href="//g' |
                        sed 's/"//g' |
                        sort -V |
                        tail -n 1)

    if [ -z "$latest_file" ]; then
        echo -e "${RED}[ERROR]${NC} No package found for architecture $arch"
        echo -e "${LIGHT_BLUE}[INFO]${NC} https://www.cyberciti.biz/faq/installing-dnscrypt-proxy-on-debian-linux"
        exit 1
    fi

    # Complete package URL
    local package_url="${repo_url}${latest_file}"

    echo -e "${GREEN}[SUCCESS]${NC} Package found: ${YELLOW}$latest_file${NC}"
    echo -e "${CYAN}[INFO]${NC} URL: ${LIGHT_BLUE}$package_url${NC}"

    # Create temporary directory for download
    local temp_dir=$(mktemp -d)
    local deb_file="$temp_dir/$latest_file"

    echo -e "${CYAN}[INFO]${NC} Downloading package..."
    if ! wget -q "$package_url" -O "$deb_file"; then
        echo -e "${RED}[ERROR]${NC} Error downloading the package"
        rm -rf "$temp_dir"
        exit 1
    fi

    echo -e "${CYAN}[INFO]${NC} Installing package..."
    if sudo dpkg -i "$deb_file"; then
        echo -e "${CYAN}[INFO]${NC} Resolving any missing dependencies..."
        sudo apt-get install -f -y
        echo -e "${GREEN}[SUCCESS]${NC} Installation completed successfully!"
    else
        echo -e "${YELLOW}[WARNING]${NC} Error during installation. Attempting to resolve dependencies..."
        sudo apt-get install -f -y
        if sudo dpkg -i "$deb_file"; then
            echo -e "${GREEN}[SUCCESS]${NC} Installation completed successfully!"
        else
            echo -e "${RED}[ERROR]${NC} Installation failed."
            rm -rf "$temp_dir"
            exit 1
        fi
    fi

    # Clean up temporary files
    rm -rf "$temp_dir"

    echo -e "${GREEN}[SUCCESS]${NC} dnscrypt-proxy has been installed and configured"
    echo -e "${CYAN}[INFO]${NC} You can check its status with: ${YELLOW}sudo systemctl status dnscrypt-proxy${NC}"
}

install_latest_dnscrypt_proxy
exit 0
