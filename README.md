AWS EC2 Initial Setup Script This script helps automate the process of setting up an initial user and hostname on a newly spun-up AWS EC2 instance. It's designed to increase security by allowing you to easily transition away from the default EC2 user setup.



Features: Prompts for a new username and desired hostname. Dynamically determines the current logged-in user to copy SSH key configurations. Creates a new user and grants it sudo permissions without needing a password. Sets a custom hostname for the instance.



Usage: Clone this repository or directly download the setup_aws.sh script to your EC2 instance.
git clone https://github.com/HezhaKh/ops345.git



Navigate to the directory containing the script:
cd /path/to/script/directory/

Make the script executable:
chmod +x setup_aws.sh

Execute the script with sudo:
sudo ./setup_aws.sh

Follow the on-screen prompts to enter the desired username and hostname.



Purpose:
-Check for Root/Sudo Privileges
-Prompt for New Username and Hostname
-Prompt for Sudoers File name
-Get Current User's Username
-Create New User
-Give New User Sudo Privileges without Password
-Set Correct Permissions for the Sudoers File
-Copy SSH Key to New User
-Set New Hostname
-Print Completion Message
