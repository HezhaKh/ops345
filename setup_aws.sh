#!/bin/bash

#Author: Hezha
#Date: Sep 23rd 2023
#updatedDate: Jan 21st 2024
#Purpose: Change the preserve_hostname: true > false in cloud.cfg, New Username and Hostname, New User Sudo Privileges without Password, Copy SSH Key to New User.
#Usage: ./setup_aws.sh

function update_preserve_hostname() {
    local file="/etc/cloud/cloud.cfg"
    if [ -w "$file" ]; then
        if grep -q "^preserve_hostname:" "$file"; then
            sed -i 's/^preserve_hostname: false/preserve_hostname: true/' "$file"
        else
            echo "preserve_hostname: true" >> "$file"
        fi
        echo "Updated preserve_hostname to true in $file"
    else
        echo "Error: $file is not writable. Run the script as a superuser or check file permissions."
    fi
}

# Ensure the user is running this script with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root or with sudo privileges."
   exit 1
fi

# Ask the user for the new username and desired hostname
read -p "Enter the new username: " NEW_USER
read -p "Enter the desired hostname: " NEW_HOSTNAME

# Ask user for sudoers filename or use the default
read -p "Enter the filename to store sudoers configuration (default: 10-ops345-users): " SUDOERS_FILE
if [[ -z "$SUDOERS_FILE" ]]; then
    SUDOERS_FILE="10-ops345-users"
fi

# Get the current username (the user you logged in as)
CURRENT_USER=$(logname)

# Create the new user
useradd -m -d /home/$NEW_USER -s /bin/bash $NEW_USER

# Grant the new user sudo permissions without password
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SUDOERS_FILE

# Set the right permissions for the sudoers file
chmod 0440 /etc/sudoers.d/$SUDOERS_FILE

# Copy SSH key to the new user
rsync -a /home/$CURRENT_USER/.ssh/ /home/$NEW_USER/.ssh/
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/

# Set the hostname
hostnamectl set-hostname $NEW_HOSTNAME

# Update preserve_hostname to true in /etc/cloud/cloud.cfg
update_preserve_hostname

echo "User and hostname set. Please test by logging in as $NEW_USER and delete it if necessary."