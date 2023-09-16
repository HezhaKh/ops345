#!/bin/bash
#Author: hkhoshnoud
#Date: Sep 16th 2023
#Purpose: Instance setup for OPS345 Labs
#Usage: ./setup_aws.sh

# Ensure the user is running this script with sudo privileges
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root or with sudo privileges."
   exit 1
fi

# Ask the user for the new username and desired hostname
read -p "Enter the new username: " NEW_USER
read -p "Enter the desired hostname: " NEW_HOSTNAME

# Get the current username (the user you logged in as)
CURRENT_USER=$(logname)

# Create the new user
useradd $NEW_USER

# Grant the new user sudo permissions without password
echo "$NEW_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/10-ops345-users

# Set the right permissions for the sudoers file
chmod 0440 /etc/sudoers.d/10-ops345-users

# Copy SSH key to the new user
rsync -a /home/$CURRENT_USER/.ssh/ /home/$NEW_USER/.ssh/
chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/.ssh/

# Set the hostname
hostnamectl set-hostname $NEW_HOSTNAME

echo "User and hostname set. Please test by logging in as $NEW_USER and delete it if necessary."