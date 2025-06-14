# AWS EC2 & Ubuntu Initial Setup Script

This script automates the initial setup of a new EC2 instance or Ubuntu server. It allows for a secure and streamlined transition from the default system user to a custom setup, including user creation, hostname setting, and SSH key transfer.

---

## Features

- **Cross-Compatible:** Works on both Amazon Linux and Ubuntu (tested on Ubuntu 24.04+ and Amazon Linux 2023 kernel-6.1).
- **User Creation:** Adds a new user with a home directory and bash shell.
- **Hostname Configuration:** Prompts for and sets a new hostname.
- **SSH Key Transfer:** Copies `.ssh` keys from the current user to the new user.
- **Passwordless Sudo:** Grants new user `sudo` access without requiring a password.
- **Preserve Hostname Setting:** Modifies `/etc/cloud/cloud.cfg` to ensure the custom hostname persists after reboot.
- **Sudo Check & Auto-Install:** Ensures `sudo` is installed (for minimal Ubuntu/Amazon Linux images).

---

## Usage

1. **Clone the Repository**
   ```bash
   git clone https://github.com/HezhaKh/ops345.git
   ```

2. **Navigate to the Script Directory**
   ```bash
   cd ./ops345
   ```

3. **Make the Script Executable**
   ```bash
   chmod +x ./setup_aws.sh
   ```

4. **Run the Script as Root or with Sudo**
   ```bash
   sudo ./setup_aws.sh
   ```

5. **Follow the Prompts**
   - Enter a **new username** (e.g., `admin`).
   - Enter a **custom hostname** (e.g., `myserver01`).
   - Optionally enter a **sudoers file name** (default is `10-ops345-users`).

6. **(Optional)** Remove the Default EC2 User
   ```bash
   sudo userdel -r ec2-user
   ```

---

##  Script Breakdown

- Verifies root/sudo privileges before continuing.
- Prompts for and creates a new user.
- Transfers SSH keys from the current user.
- Assigns `NOPASSWD:ALL` sudo permission to the new user.
- Sets the hostname using `hostnamectl`.
- Edits `/etc/cloud/cloud.cfg` to ensure hostname persists across reboots.
- Conditionally installs `sudo` using `apt` (Ubuntu) or `yum` (Amazon Linux) if not present.

---

## Notes

- The script uses `logname` to identify the current SSH user (e.g., `ubuntu` or `ec2-user`). Make sure you run the script from a valid user shell.
- If the `.ssh` directory doesn’t exist for the current user, the SSH key copy step will be skipped with a warning.
- You must run this script with `sudo` or as the `root` user.

---

## Final Tip

After setup, test logging in as the new user. Once confirmed, you can safely remove the default EC2 or Ubuntu user.

---
