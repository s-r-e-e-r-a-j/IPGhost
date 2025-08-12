#!/bin/bash

# Function to detect the operating system
detect_os() {
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "macos"
    elif [[ -f /etc/debian_version ]]; then
        echo "debian"
    elif [[ -f /etc/redhat-release ]]; then
        echo "redhat"
    else
        echo "unknown"
    fi
}

# Function to install on Debian-based systems
install_debian() {
    echo "[+] Detected Debian-based system (Ubuntu/Kali/Parrot)"
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        echo "[!] Please run this installer with sudo on Linux systems"
        exit 1
    fi

    # Install the Bash tool
    chmod 755 ipghost.sh
    mkdir -p /usr/share/ipghost
    cp ipghost.sh /usr/share/ipghost/ipghost.sh

    # Create executable wrapper
    cat <<EOL > /usr/bin/ipghost
#!/bin/bash
exec /usr/share/ipghost/ipghost.sh "\$@"
EOL

    chmod +x /usr/bin/ipghost
    chmod +x /usr/share/ipghost/ipghost.sh

    echo -e "\n\nCongratulations! IPGhost is installed successfully."
    echo -e "From now, just type ipghost in the terminal."
    echo -e "Note: Run with sudo: sudo ipghost"
}

# Function to install on macOS
install_macos() {
    echo "[+] Detected macOS system"

    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo "[!] Homebrew is required but not installed."
        echo "[+] Please install Homebrew first:"
        echo "    /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    # Check if netcat is available
    if ! command -v nc >/dev/null 2>&1; then
        echo "[!] netcat is required but not installed."
        echo "[+] Installing netcat..."
        brew install netcat
    fi

    # Check if the macOS script exists
    if [ ! -f "ipghost_macos.sh" ]; then
        echo "[!] ipghost_macos.sh not found. Please ensure you have the macOS version of the script."
        exit 1
    fi

    # Create application directory
    INSTALL_DIR="/usr/local/share/ipghost"
    BIN_DIR="/usr/local/bin"
    
    # Install the Bash tool
    chmod 755 ipghost_macos.sh
    sudo mkdir -p "$INSTALL_DIR"
    sudo cp ipghost_macos.sh "$INSTALL_DIR/ipghost.sh"

    # Create executable wrapper
    sudo cat <<EOL > "$BIN_DIR/ipghost"
#!/bin/bash
exec "$INSTALL_DIR/ipghost.sh" "\$@"
EOL

    sudo chmod +x "$BIN_DIR/ipghost"
    sudo chmod +x "$INSTALL_DIR/ipghost.sh"

    echo -e "\n\nCongratulations! IPGhost for macOS is installed successfully."
    echo -e "From now, just type ipghost in the terminal."
    echo -e "Note: This version does not require sudo to run."
}

# Function to uninstall on Debian-based systems
uninstall_debian() {
    echo "[+] Uninstalling IPGhost from Debian-based system"
    
    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
        echo "[!] Please run this uninstaller with sudo on Linux systems"
        exit 1
    fi

    # Uninstall the Bash tool
    rm -rf /usr/share/ipghost
    rm -f /usr/bin/ipghost

    echo "[!] IPGhost has been removed successfully."
}

# Function to uninstall on macOS
uninstall_macos() {
    echo "[+] Uninstalling IPGhost from macOS system"
    
    # Uninstall the Bash tool
    sudo rm -rf /usr/local/share/ipghost
    sudo rm -f /usr/local/bin/ipghost

    echo "[!] IPGhost has been removed successfully."
}

# Main installation logic
main() {
    # Detect operating system
    OS=$(detect_os)
    
    echo "[+] Operating System: $OS"
    echo ""
    
    # Prompt the user for installation or uninstallation
    echo "[+] To install, press (Y). To uninstall, press (N): "
    read -r choice

    if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
        case $OS in
            "debian")
                # Check if the Linux script exists
                if [ ! -f "ipghost.sh" ]; then
                    echo "[!] ipghost.sh not found. Please ensure you have the Linux version of the script."
                    exit 1
                fi
                install_debian
                ;;
            "macos")
                install_macos
                ;;
            "redhat")
                echo "[!] Red Hat based systems are not officially supported."
                echo "[+] You may try adapting the Debian installation manually."
                exit 1
                ;;
            "unknown")
                echo "[!] Unsupported operating system."
                echo "[+] This installer supports Debian-based Linux and macOS only."
                exit 1
                ;;
        esac

    elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
        case $OS in
            "debian")
                uninstall_debian
                ;;
            "macos")
                uninstall_macos
                ;;
            *)
                echo "[!] Uninstallation for this OS is not supported."
                exit 1
                ;;
        esac

    else
        # Invalid choice
        echo "[!] Invalid choice. Exiting."
        exit 1
    fi
}

# Run the main function
main
