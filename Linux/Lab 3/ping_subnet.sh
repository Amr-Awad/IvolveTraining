#!/bin/bash

# Get the current IP address dynamically
MY_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+\.\d+\.\d+\.\d+' | grep -v '127.0.0.1' | head -n 1)

# Extract the first three octets (s.s.s)
SUBNET=$(echo "$MY_IP" | awk -F. '{print $1"."$2"."$3}')

echo "Scanning network: $SUBNET.x (where x = 0 to 255)..."

# Loop through all possible last octets (0-255)
for i in {0..255}; do
    IP="$SUBNET.$i"

    # Ping each IP with a 1-second timeout and 1 packet
    if ping -c 1 -W 1 "$IP" &> /dev/null; then
        echo "Server $IP is up and running"
    else
        echo "Server $IP is unreachable"
    fi
done
