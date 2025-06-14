#!/bin/bash

# Author: Hezha
# Date: Sep 23rd 2023
# Updated: Jun 14th 2025
# Purpose: Automate user creation, hostname setup, sudo privileges, and SSH key transfer
# Compatibility: Amazon Linux and Ubuntu
# Usage: sudo ./setup_aws.sh

#----------------------------
# Function: Update preserve_hostname in cloud-init config
#----------------------------
function update_preserve_hostname() {
    local file="/etc/cloud/cloud.cfg"

    if [ ! -f "$file" ]; then
        echo "File $file does not exist, skipping preserve_hostname update."
        return
    fi

    if [ -w "$file" ]; then
        if grep -q "^preserve_hostname:" "$file"; then
            # Replace if the key exists
            sed -i 's/^preserve_hostname: .*/preserve_hostname: true/' "$file"
        else
            # Append if the key doesn't exist
            echo "preserve_hostname: true" >> "$file"
        fi
        echo "Updated preserve_hostname to true in $file"
    else
        echo "Error: $file is not writable. Run the script with sudo."
    fi
}

#----------------------------
# Ensure script is run with sudo/root
#----------------------------
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root or with sudo privileges."
   exit 1
fi

#----------------------------
# Ensure sudo is installed (for minimal images) [Most of the OS today comes with sudo installed]
#----------------------------
if ! command -v sudo &> /dev/null; then
#    echo "sudo not found. Attempting to install..."
#    if [ -f /etc/debian_version ]; then
#        apt update && apt install -y sudo
#    elif [ -f /etc/redhat-release ]; then
#        dnf install -y sudo
#    else
#        echo "Unsupported OS. Please install sudo manually."
#        exit 1
#    fi
#fi

#----------------------------
# Prompt user for inputs
#----------------------------
read -p "Enter the new username: " NEW_USER
read -p "Enter the desired hostname: " NEW_HOSTNAME

# Optional: custom sudoers file name
read -p "Enter the filename to store sudoers configuration (default: 10-ops345-users): " SUDOERS_FILE
if [[ -z "$SUDOERS_FILE" ]]; then
    SUDOERS_FILE="10-ops345-users"
fi

CURRENT_USER=$(logname)

#----------------------------
# Create new user and home directory
#----------------------------
useradd -m -d /home/$NEW_USER -s /bin/bash $NEW_USER

#----------------------------
# Add user to sudoers with no password requirement
#----------------------------
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SUDOERS_FILE
chmod 0440 /etc/sudoers.d/$SUDOERS_FILE

#----------------------------
# Copy SSH keys from current user to new user (if present)
#----------------------------
if [ -d /home/$CURRENT_USER/.ssh ]; then
    rsync -a /home/$CURRENT_USER/.ssh/ /home/$NEW_USER/.ssh/
    chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/
    chmod 700 /home/$NEW_USER/.ssh
    chmod 600 /home/$NEW_USER/.ssh/authorized_keys 2>/dev/null
    echo "SSH keys copied from $CURRENT_USER to $NEW_USER"
else
    echo "No SSH directory found for $CURRENT_USER, skipping key transfer."
fi

#----------------------------
# Set the hostname
#----------------------------
hostnamectl set-hostname $NEW_HOSTNAME
echo "Hostname set to $NEW_HOSTNAME"

#----------------------------
# Update cloud-init config to preserve hostname
#----------------------------
update_preserve_hostname

echo -e "\n Script complete! You can now log in as $NEW_USER. Test before deleting old user if necessary."
