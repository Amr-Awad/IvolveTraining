# Linux System Administration Automation Tasks

## Overview
This repository contains a collection of automation scripts for various system administration tasks. Each script automates a specific function, making Linux system setup, configuration, and maintenance easier.

## Tasks Overview

### 1. Create User and Install Nginx with Sudo Privileges
This script automates the process of creating a new user (`ivolve_employee`), assigning it to a group (`ivolve`), and granting sudo privileges to install Nginx without a password prompt.

🔗 [Read More](./Lab%201/README.md)

### 2. MySQL Backup Cron Job Setup
This script sets up MySQL, configures necessary permissions, and schedules a cron job to take automatic backups of all databases every Sunday at 5 AM.

🔗 [Read More](./Lab%202/README.md)

### 3. Ping Subnet Script
This script scans the local subnet and identifies which IPs are reachable, aiding in network troubleshooting and diagnostics.

🔗 [Read More](./Lab%203/README.md)

### 4. Partitioning and Mounting Script
This script partitions a disk, sets up swap space, configures logical volume management (LVM), formats the partitions, and ensures persistence across reboots.

🔗 [Read More](./Lab%204/README.md)

### 5. SSH Key-Based Authentication Setup
This script automates SSH key pair generation, copies the public key to a remote server, and configures SSH settings for passwordless login with an alias.

🔗 [Read More](./Lab%205/README.md)

## Conclusion
These scripts provide a streamlined approach to common system administration tasks, reducing manual effort and ensuring consistency across configurations. Check the respective `README.md` files for detailed setup instructions and usage guidelines.

