#!/bin/bash

# Define variables
KEY_PATH="$HOME/.ssh/ivolve_key"
CONFIG_PATH="$HOME/.ssh/config"
REMOTE_USER="student"  # Change this to the appropriate username
REMOTE_IP="serverb"  # Change this to your VM's actual IP

# Generate SSH key pair if it doesn't exist
if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -f "$KEY_PATH" -N ""
else
    echo "SSH key already exists, skipping generation."
fi

# Copy the public key to the remote server
echo "Copying public key to remote server..."
ssh-copy-id -i "$KEY_PATH.pub" "$REMOTE_USER@$REMOTE_IP"

# Configure SSH for simplified access
echo "Configuring SSH..."
if ! grep -q "Host ivolve" "$CONFIG_PATH"; then
    echo -e "\nHost ivolve\n    HostName $REMOTE_IP\n    User $REMOTE_USER\n    IdentityFile $KEY_PATH" >> "$CONFIG_PATH"
    chmod 600 "$CONFIG_PATH"
    echo "SSH configuration updated."
else
    echo "SSH configuration already exists."
fi

# Set permissions
chmod 600 "$KEY_PATH"
chmod 644 "$KEY_PATH.pub"

echo "Setup complete! You can now SSH using: ssh ivolve"
