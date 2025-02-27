#!/bin/bash

set -e  # Exit on error

DISK="/dev/xvdb"

# Define partitions
PART1="${DISK}1"
PART2="${DISK}2"
PART3="${DISK}3"
PART4="${DISK}4"
VG_NAME="my_vg"
LV_NAME="my_lv"
MOUNT1="/mnt/data"
MOUNT2="/mnt/lv_data"

# Check if the disk exists
if [[ ! -b "$DISK" ]]; then
    echo "Error: Disk $DISK does not exist!"
    exit 1
fi

echo "Checking existing partitions..."
lsblk "$DISK"

# Function to check if a partition exists
partition_exists() {
    [[ -b "$1" ]]
}

# Function to check if a partition is mounted
is_mounted() {
    mount | grep -q " $1 "
}

# Create partitions if they don’t exist
if ! partition_exists "$PART1"; then
    echo "Creating partitions on $DISK..."
    sudo parted -s "$DISK" mklabel gpt
    sudo parted -s "$DISK" mkpart primary ext4 1MiB 4097MiB  # 4GB
    sudo parted -s "$DISK" mkpart primary linux-swap 4097MiB 6145MiB  # 2GB
    sudo parted -s "$DISK" mkpart primary ext4 6145MiB 12289MiB  # 6GB
    sudo parted -s "$DISK" mkpart primary ext4 12289MiB 100%  # Remaining space
    sleep 5  # Give system time to recognize partitions
else
    echo "Partitions already exist. Skipping partitioning step."
fi

# Format partition 1 (if not formatted)
if [[ "$(blkid -o value -s TYPE "$PART1")" != "ext4" ]]; then
    echo "Formatting $PART1 as ext4..."
    sudo mkfs.ext4 "$PART1"
else
    echo "$PART1 already formatted. Skipping."
fi

# Format partition 2 as swap (if not already swap)
if [[ "$(blkid -o value -s TYPE "$PART2")" != "swap" ]]; then
    echo "Setting up swap on $PART2..."
    sudo mkswap "$PART2"
    sudo swapon "$PART2"
else
    echo "$PART2 is already swap. Skipping."
fi

# Create LVM if not already created
if ! sudo vgdisplay "$VG_NAME" &>/dev/null; then
    echo "Creating LVM setup..."
    sudo pvcreate "$PART3"
    sudo vgcreate "$VG_NAME" "$PART3"
    sudo lvcreate -L 5G -n "$LV_NAME" "$VG_NAME"
else
    echo "LVM already exists. Skipping creation."
fi

# Extend LV if partition 4 is available
if partition_exists "$PART4" && ! sudo pvs | grep -q "$PART4"; then
    echo "Extending LVM with $PART4..."
    sudo pvcreate "$PART4"
    sudo vgextend "$VG_NAME" "$PART4"
    sudo lvextend -l +100%FREE "/dev/$VG_NAME/$LV_NAME"
else
    echo "LVM already extended or $PART4 doesn't exist. Skipping."
fi

# Format logical volume (if not formatted)
if [[ "$(blkid -o value -s TYPE "/dev/$VG_NAME/$LV_NAME")" != "ext4" ]]; then
    echo "Formatting logical volume as ext4..."
    sudo mkfs.ext4 "/dev/$VG_NAME/$LV_NAME"
else
    echo "Logical volume already formatted. Skipping."
fi

# Ensure mount points exist
sudo mkdir -p "$MOUNT1"
sudo mkdir -p "$MOUNT2"

# Mount partition 1 if not mounted
if ! is_mounted "$MOUNT1"; then
    echo "Mounting $PART1 to $MOUNT1..."
    UUID_PART1=$(blkid -s UUID -o value "$PART1")
    sudo mount "$PART1" "$MOUNT1"
    echo "UUID=$UUID_PART1 $MOUNT1 ext4 defaults 0 2" | sudo tee -a /etc/fstab
else
    echo "$MOUNT1 is already mounted. Skipping."
fi

# Mount logical volume if not mounted
if ! is_mounted "$MOUNT2"; then
    echo "Mounting LV to $MOUNT2..."
    UUID_LV=$(blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")
    sudo mount "/dev/$VG_NAME/$LV_NAME" "$MOUNT2"
    echo "UUID=$UUID_LV $MOUNT2 ext4 defaults 0 2" | sudo tee -a /etc/fstab
else
    echo "$MOUNT2 is already mounted. Skipping."
fi

# Enable swap if not already active
if ! swapon --show | grep -q "$PART2"; then
    echo "Enabling swap..."
    sudo swapon "$PART2"
    UUID_SWAP=$(blkid -s UUID -o value "$PART2")
    echo "UUID=$UUID_SWAP swap swap defaults 0 0" | sudo tee -a /etc/fstab
else
    echo "Swap already active. Skipping."
fi

echo "Partitioning and mounting complete!"
lsblk
