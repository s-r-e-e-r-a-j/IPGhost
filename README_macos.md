# IPGhost for macOS

IPGhost is a strong tool for ethical hackers. It helps you stay private and anonymous online by using the Tor network. This tool automatically changes your IP address, making it hard for anyone to track your online activities.

This version has been specifically adapted for macOS systems.

## Features

- Automatic installation of required dependencies (Tor, curl, jq) using Homebrew.
- Changing your IP address regularly through Tor to stay anonymous.
- Display of the current Tor-routed IP address after every IP address change.
- Display of the location details (Country, Region, and City).
- User-defined IP address change interval and cycle count (or infinite mode).
- Automatically stops the Tor service upon exit to prevent unnecessary resource usage.
- SOCKS proxy setup instructions for routing your applications through Tor.
- No root privileges required for normal operation.

## Requirements

- macOS operating system (tested on macOS 10.15 and newer).
- Homebrew package manager.
- Active internet connection.
- Administrator privileges only for initial installation.

## Installation

**Step 1: Install Homebrew (if not already installed)**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**Step 2: Install netcat (required for Tor control)**

```bash
brew install netcat
```

**Step 3: Download and Install IPGhost**

1. **Clone the repository or download the files:**
   
```bash
git clone https://github.com/s-r-e-e-r-a-j/IPGhost.git
```

2. **Navigate to the IPGhost directory:**
   
```bash
cd IPGhost
```

3. **Make the macOS script executable:**
   
```bash
chmod +x ipghost_macos.sh
```

4. **Run the install script to set up IPGhost:**

```bash
sudo bash install_macos.sh
```

Then enter Y for install.

## Usage

**Step 1: Start IPGhost**

After installation, start IPGhost by running:

```bash
ipghost
```

Note: Unlike the Linux version, this does not require sudo to run.

**The tool will automatically install necessary dependencies (Tor, curl, jq) using Homebrew if they are not present.**

**Step 2: Configure SOCKS Proxy**

To route your internet traffic through Tor, configure your applications to use the Tor SOCKS proxy:

- **Proxy Address:** 127.0.0.1
- **Port:** 9050

### Browser Configuration Examples:

**Firefox (Recommended):**

1. Go to Settings > General > Network Settings > Configure
2. Select Manual proxy configuration
3. Set SOCKS Host to 127.0.0.1 and Port to 9050
4. Select SOCKS v5
5. Check "Proxy DNS when using SOCKS v5"
6. Save the settings

**Chrome/Safari:**

Install the "Proxy SwitchyOmega" extension and configure:
- Protocol: SOCKS5
- Server: 127.0.0.1
- Port: 9050

**Tor Browser (Easiest option):**

```bash
brew install --cask tor-browser
```

## How It Works

1. **Start Tor Service:** IPGhost automatically starts the Tor service when launched using native macOS processes.

2. **IP Change:**
   - Prompts the user for an IP address change interval (default: 60 seconds) and the number of IP address changes (0 for infinite).
   - Sends control signals to Tor to change identity and fetches the new IP address.

3. **Monitor New IP:**
   - Displays the Tor-assigned IP after each IP address change.
   - Shows location details (Country, Region, and City) in green color for better visibility.

4. **Stop Tor on Exit:**
   - When IPGhost exits, it automatically stops the Tor service to conserve system resources.

## Example Output

```
  _____ _____     _____ _               _   
 |_   _|  __ \   / ____| |             | |  
   | | | |__) | | |  __| |__   ___  ___| |_ 
   | | |  ___/  | | |_ | '_ \ / _ \/ __| __|
  _| |_| |      | |__| | | | | (_) \__ \ |_ 
 |_____|_|       \_____|_| |_|\___/|___/\__|

                         Developer: Sreeraj
                         Adapted for macOS

* GitHub: https://github.com/s-r-e-e-r-a-j

Change your SOCKS to 127.0.0.1:9050

[+] Checking dependencies...
[+] Tor is already installed.
[+] curl is already installed.
[+] jq is already installed.
[+] Starting Tor service...
[+] Tor service started successfully (PID: 12345).
[+] Initial IP and location:
[+] New IP: 103.251.167.20
[+] Location:
   Country: India
   Region: Maharashtra
   City: Mumbai
[+] Enter interval (seconds) between IP changes [default: 60]: 30
[+] Enter number of IP changes (0 for infinite): 5
[+] Infinite mode activated. Press Ctrl+C to stop.
[~] Changing identity...
[~] Identity changed.
[+] New IP: 185.129.61.4
[+] Location:
   Country: Netherlands
   Region: North Holland
   City: Amsterdam
```

## Troubleshooting

**Permission Issues:**
If you encounter permission errors with Tor data directory:

```bash
rm -rf ~/.tor ~/.tor_temp
mkdir -p ~/.tor ~/.tor_temp
chmod 700 ~/.tor ~/.tor_temp
```

**Port Already in Use:**
The script automatically handles port conflicts, but you can manually check:

```bash
lsof -i :9050
lsof -i :9051
```

**Tor Connection Issues:**
Test Tor connectivity manually:

```bash
curl --socks5 127.0.0.1:9050 http://httpbin.org/ip
```

## Stopping IPGhost

- **Infinite Mode:** Press Ctrl+C to stop.
- **Fixed IP Address Change:** The tool will automatically terminate after completing the specified number of cycles.
- **Tor service stops automatically upon exiting the tool.**

## Uninstallation

```bash
cd IPGhost
sudo bash install_macos.sh
```

Then enter N for uninstall.

## Differences from Linux Version

- Uses Homebrew instead of apt for package management
- Uses native macOS process management instead of systemd services
- Does not require root privileges for normal operation
- Uses Tor control port for identity changes instead of service reload
- Enhanced error handling and diagnostics for macOS environment

## Security Notes

- Never run Tor as root user
- The script creates temporary data directories with proper permissions
- All network traffic routing must be configured manually in applications
- For maximum security, consider using Tor Browser instead of configuring regular browsers

## License

This tool is open-source and available under the MIT License.

## Author

- **Sreeraj**
- **GitHub:** https://github.com/s-r-e-e-r-a-j
- **macOS Adaptation:** Enhanced for macOS compatibility

## Contributing

Contributions are welcome. Please ensure any modifications maintain compatibility with macOS systems and follow security best practices.
