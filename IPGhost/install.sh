#!/usr/bin/env bash

# Prompt the user for installation or uninstallation
echo "[+] To install, press (Y). To uninstall, press (N): "
read -r choice

if [[ "$choice" == "Y" || "$choice" == "y" ]]; then
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

    echo -e "\n\nCongratulations! IpGhost is installed successfully."
    echo -e "From now, just type \033[1;32mipghost\033[0m in the terminal."

elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    # Uninstall the Bash tool
    rm -rf /usr/share/ipghost
    rm -f /usr/bin/ipghost

    echo "[!] IpGhost has been removed successfully."
else
    # Invalid choice
    echo "[!] Invalid choice. Exiting."
fi
