#!/bin/bash

# ANSI color codes
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[92m"
YELLOW="\033[93m"
RED="\033[91m"

# Check if the user is running as root or with sudo
check_sudo() {
    if [ "$EUID" -ne 0 ]; then
        echo -e "${YELLOW} Please run this tool as root or with sudo${RESET}"
        exit 1
    fi
}

# Function to check and install dependencies
install_dependencies() {
    echo -e "${GREEN}[+] Checking dependencies...${RESET}"

    # Check if Homebrew is installed
    if ! command -v brew >/dev/null 2>&1; then
        echo -e "${RED}[!] Homebrew is not installed. Please install Homebrew first:${RESET}"
        echo -e "${YELLOW}/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"${RESET}"
        exit 1
    fi

    # Check and install Tor
    if ! command -v tor >/dev/null 2>&1; then
        echo -e "${RED}[!] Tor is not installed. Installing Tor...${RESET}"
        brew install tor
        echo -e "${GREEN}[+] Tor installed successfully.${RESET}"
    else
        echo -e "${GREEN}[+] Tor is already installed.${RESET}"
    fi

    # Check and install curl (usually pre-installed on macOS)
    if ! command -v curl >/dev/null 2>&1; then
        echo -e "${RED}[!] curl is not installed. Installing curl...${RESET}"
        brew install curl
        echo -e "${GREEN}[+] curl installed successfully.${RESET}"
    else
        echo -e "${GREEN}[+] curl is already installed.${RESET}"
    fi

    # Check and install jq
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${RED}[!] jq is not installed. Installing jq...${RESET}"
        brew install jq
        echo -e "${GREEN}[+] jq installed successfully.${RESET}"
    else
        echo -e "${GREEN}[+] jq is already installed.${RESET}"
    fi
}

# Display banner
display_banner() {
    clear
    echo -e "${GREEN}${BOLD}"
    cat << "EOF"
     
  _____ _____     _____ _               _   
 |_   _|  __ \   / ____| |             | |  
   | | | |__) | | |  __| |__   ___  ___| |_ 
   | | |  ___/  | | |_ | '_ \ / _ \/ __| __|
  _| |_| |      | |__| | | | | (_) \__ \ |_ 
 |_____|_|       \_____|_| |_|\___/|___/\__|

                         Developer: Sreeraj
                         Adapted for macOS                                                        
EOF
    echo -e "${RESET}${YELLOW}* GitHub: https://github.com/s-r-e-e-r-a-j${RESET}"
    echo
    echo -e "${GREEN}Change your SOCKS to 127.0.0.1:9050${RESET}"
    echo
}

# Start Tor service (macOS version)
initialize_tor() {
    echo -e "${GREEN}[+] Starting Tor service...${RESET}"
    
    # Check if Tor is already running
    if pgrep -x "tor" > /dev/null; then
        echo -e "${YELLOW}[!] Tor is already running. Stopping existing instance...${RESET}"
        pkill tor
        sleep 2
    fi
    
    # Start Tor in background
    tor --SOCKSPort 9050 --ControlPort 9051 --HashedControlPassword "" --CookieAuthentication 0 &
    TOR_PID=$!
    
    # Wait a moment for Tor to initialize
    sleep 3
    
    if kill -0 $TOR_PID 2>/dev/null; then
        echo -e "${GREEN}[+] Tor service started (PID: $TOR_PID).${RESET}"
    else
        echo -e "${RED}[!] Failed to start Tor service.${RESET}"
        exit 1
    fi
}

# Stop Tor service when exiting (macOS version)
cleanup() {
    echo -e "${RED}[!] Stopping Tor service...${RESET}"
    if [ ! -z "$TOR_PID" ] && kill -0 $TOR_PID 2>/dev/null; then
        kill $TOR_PID
        echo -e "${RED}[!] Tor service stopped.${RESET}"
    else
        # Fallback: kill any running Tor processes
        pkill tor
        echo -e "${RED}[!] Tor processes terminated.${RESET}"
    fi
    exit 0
}

# Handle script termination
trap cleanup SIGINT SIGTERM

# Change identity using Tor (macOS version)
change_identity() {
    echo -e "${YELLOW}[~] Changing identity...${RESET}"
    
    # Send NEWNYM signal to Tor control port
    echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051 2>/dev/null
    
    # Alternative method if netcat doesn't work
    if [ $? -ne 0 ]; then
        # Restart Tor process
        if [ ! -z "$TOR_PID" ] && kill -0 $TOR_PID 2>/dev/null; then
            kill $TOR_PID
            sleep 2
        fi
        tor --SOCKSPort 9050 --ControlPort 9051 --HashedControlPassword "" --CookieAuthentication 0 &
        TOR_PID=$!
        sleep 3
    fi
    
    echo -e "${YELLOW}[~] Identity changed.${RESET}"
}

# Fetch external IP and location using ipapi.co and Tor
fetch_ip_and_location() {
    local ip country region city

    ip=$(curl --silent --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 http://httpbin.org/ip | jq -r .origin 2>/dev/null)

    if [ -z "$ip" ] || [ "$ip" = "null" ]; then
        echo -e "${RED}Error: Unable to fetch IP. Check if Tor is running properly.${RESET}"
    else
        location=$(curl --silent --socks5 127.0.0.1:9050 --socks5-hostname 127.0.0.1:9050 "https://ipapi.co/$ip/json/" | jq -r '.country_name, .region, .city' 2>/dev/null)

        country=$(echo "$location" | sed -n '1p')
        region=$(echo "$location" | sed -n '2p')
        city=$(echo "$location" | sed -n '3p')

        echo -e "${GREEN}[+] New IP: $ip${RESET}"
        echo -e "${GREEN}[+] Location:${RESET}"
        echo -e "${GREEN}   Country: $country${RESET}"
        echo -e "${GREEN}   Region: $region${RESET}"
        echo -e "${GREEN}   City: $city${RESET}"
    fi
}

# Main function for IP changing
main() {
    display_banner
    initialize_tor

    echo -ne "${YELLOW}[+] Enter interval (seconds) between IP changes [default: 60]: ${RESET}"
    read -r interval
    interval=${interval:-60}

    echo -ne "${YELLOW}[+] Enter number of IP changes (0 for infinite): ${RESET}"
    read -r cycles
    cycles=${cycles:-0}

    # Show initial IP
    echo -e "${GREEN}[+] Initial IP and location:${RESET}"
    fetch_ip_and_location

    if [[ "$cycles" -eq 0 ]]; then
        echo -e "${GREEN}[+] Infinite mode activated. Press Ctrl+C to stop.${RESET}"
        while true; do
            sleep "$interval"
            change_identity
            fetch_ip_and_location
        done
    else
        for ((i = 1; i <= cycles; i++)); do
            echo -e "${GREEN}[+] Change $i of $cycles${RESET}"
            sleep "$interval"
            change_identity
            fetch_ip_and_location
        done
    fi
}

# Remove sudo check for macOS (Tor doesn't require root)
# check_sudo

# Ensure dependencies are installed and start the script
install_dependencies

# Start IP changing
main
