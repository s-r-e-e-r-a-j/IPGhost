## IPGhost

IPGhost is a strong tool for ethical hackers. It helps you stay private and anonymous online by using the Tor network. This tool automatically changes your IP address, making it hard for anyone to track your online activities.

## Features

- Automatic installation of required dependencies (`Tor`, `curl`,`jq`).

- Changing your IP address regularly through Tor to stay anonymous.

- Display of the current Tor-routed IP address after every IP address change.

- Display of the location details (Country, Region, and City).

- User-defined IP address change interval and cycle count (or infinite mode).

- Automatically stops the Tor service upon exit to prevent unnecessary resource usage.

- SOCKS proxy setup instructions for routing your applications through Tor.

## Requirements

- Linux distributions `Debian`, `Rhel`, `Arch` (eg.,kali linux, parrot os,   Ubuntu, Arch linux, Black Arch, fedora, etc.).

- Root privileges to install dependencies and manage the Tor service.

- Active internet connection.

## Disclaimer 
IPGhost is an educational and ethical hacking tool designed to enhance online privacy using the Tor network. Use it responsibly and only for legal purposes. The developer assumes no liability for misuse of this tool.

## Installation

**Step 1: Download and Install**

1. **Clone the repository or download the files:**
   
```bash
git clone https://github.com/s-r-e-e-r-a-j/IPGhost.git
```
2. **Navigate to the IPGhost directory**
   
```bash
cd IPGhost
```
3. **Navigate to the IPGhost directory**
   
```bash
cd IPGhost
```
4. **Run the install.sh script to set up IPGhost:**

```bash
sudo bash install.sh
```

Then Enter `y` for install.

## Usage

**Step 1: Start IPGhost**
After installation, start `IPGhost` by running:

```bash
sudo ipghost
```

**After running the tool, it will automatically install necessary dependencies (Tor, curl, jq).**

**Step 2: Configure SOCKS Proxy**

To route your internet traffic through Tor, configure your applications to use the Tor SOCKS proxy:

- **Proxy Address:** `127.0.0.1`

- **Port:** `9050`

#### Example Configuration:

- **Firefox:**

1.Go to `Settings > Network Settings > Manual Proxy Configuration`.

2. Set **SOCKS Host** to `127.0.0.1` and **Port** to `9050`.

3. Select SOCKS v5.

4. Save the settings.

## How It Works

1. **Start Tor Service:** **IPGhost** automatically starts the Tor service when launched.

2. **IP Change:**

- Prompts the user for an IP address change interval (default: 60 seconds) and the number of IP address changes (0 for infinite).

- Reloads the Tor service to change identity and fetches the new IP address.

3. **Monitor New IP:**

- Displays the Tor-assigned IP after each IP address change.

- Shows location details (Country, Region, and City) in green color for better visibility.

4. **Stop Tor on Exit:**

- When IPGhost exits, it automatically stops the Tor service to conserve system resources.

## Example Output

```markdown     
  _____ _____     _____ _               _   
 |_   _|  __ \   / ____| |             | |  
   | | | |__) | | |  __| |__   ___  ___| |_ 
   | | |  ___/  | | |_ | '_ \ / _ \/ __| __|
  _| |_| |      | |__| | | | | (_) \__ \ |_ 
 |_____|_|       \_____|_| |_|\___/|___/\__|

                        Developer: Sreeraj                                            
                                            
* GitHub: https://github.com/s-r-e-e-r-a-j  

Change your SOCKS to 127.0.0.1:9050

[+] Enter interval (seconds) between IP changes [default: 60]: 30
[+] Enter number of IP changes (0 for infinite): 5
[~] Changing identity...
[~] Identity changed.
[+] New IP: 103.251.167.20
[+] Location:
    Country: India
    Region: Maharashtra
    City: Mumbai
[~] Changing identity...
[~] Identity changed.
[+] New IP: 185.129.61.4
[+] Location:
    Country: Netherlands
    Region: North Holland
    City: Amsterdam
```
## Stopping IPGhost

- **Infinite Mode:** Press `Ctrl+C` to stop.

- **Fixed IP Address Change:** The tool will automatically terminate after completing the specified number of cycles.

- **Tor service stops automatically upon exiting the tool.**

## Uninstallation

```bash
cd IPGhost

sudo bash install.sh
```
Then Enter `n`for uninstall.

## License

This tool is open-source and available under the MIT License.

## Author

- **Sreeraj**

**GitHub:** https://github.com/s-r-e-e-r-a-j

