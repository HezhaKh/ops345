# AWS EC2 Initial Setup Script

This script is designed to facilitate the initial setup of a newly instantiated AWS EC2 instance. It allows for a secure and swift transition from the default EC2 user setup by automating several setup tasks.

## Features:
- **User and Hostname Setup:** Prompts for and sets up a new username and a desired hostname.
- **SSH Key Configuration:** Dynamically determines the current logged-in user to copy SSH key configurations to the new user.
- **Sudo Permissions:** Creates a new user and grants it sudo permissions without needing a password.
- **Hostname Configuration:** Allows setting up a custom hostname for the instance.
- **Preserve Hostname Modification:** Modifies `/etc/cloud/cloud.cfg` to set `preserve_hostname`.

## Usage:
1. **Clone this Repository:**
    ```shell
    git clone https://github.com/HezhaKh/ops345.git
    ```
2. **Navigate to the Script Directory:**
    ```shell
    cd /path/to/script/directory/
    ```
3. **Make the Script Executable:**
    ```shell
    chmod +x setup_aws.sh
    ```
4. **Execute the Script with Sudo:**
    ```shell
    sudo ./setup_aws.sh
    ```
5. **Follow On-Screen Prompts:**
   - Enter the desired username.
   - Enter the desired hostname.
   - Follow any additional prompts to complete the setup.

## Purpose:
This script is purposed to:
- Verify root/sudo privileges.
- Gather inputs for new username, hostname, and sudoers filename.
- Set up a new user with sudo privileges without a password and with the correct permissions.
- Copy SSH key configurations from the current user to the new user.
- Apply the new hostname.
- Modify `preserve_hostname` in `/etc/cloud/cloud.cfg`.
- Provide a completion message with further instructions or actions.

## Final Note:
Make sure to test the new user setup and configurations after the completion of the script and adjust as necessary.
