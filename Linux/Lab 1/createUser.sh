#!/bin/bash

# Variables
GROUP_NAME="ivolve"
USER_NAME="ivolve_employee"
PASSWORD="ivolve"  # Change this to a more secure password

# Create the group if it doesn't exist
if ! getent group "$GROUP_NAME" > /dev/null 2>&1; then
    sudo groupadd "$GROUP_NAME"
    echo "Group '$GROUP_NAME' created successfully."
else
    echo "Group '$GROUP_NAME' already exists."
fi

# Create the user and assign it to the group
if ! id "$USER_NAME" > /dev/null 2>&1; then
    sudo useradd -m -g "$GROUP_NAME" -s /bin/bash "$USER_NAME"
    echo "$USER_NAME:$PASSWORD" | sudo chpasswd
    echo "User '$USER_NAME' created and added to group '$GROUP_NAME'."
else
    echo "User '$USER_NAME' already exists."
fi

# Grant sudo privilege for installing Nginx without password
SUDOERS_FILE="/etc/sudoers.d/$USER_NAME"
echo "$USER_NAME ALL=(ALL) NOPASSWD: /usr/bin/yum install nginx" | sudo tee "$SUDOERS_FILE" > /dev/null

# Set correct permissions for sudoers file
sudo chmod 440 "$SUDOERS_FILE"

echo "User '$USER_NAME' can now install Nginx without a password using sudo."