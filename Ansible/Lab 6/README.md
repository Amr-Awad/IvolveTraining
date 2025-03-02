# Ansible Automation Platform Setup

## Overview
This guide covers the installation and configuration of Ansible Automation Platform on a control node, setting up an inventory of managed hosts, and performing ad-hoc commands to verify connectivity.

## Steps Performed

### 1. Install Ansible on Red Hat
To install Ansible on the control node running Red Hat, follow these steps:
- Install Ansible:
  ```bash
  sudo yum install ansible -y
  ```
- Verify the installation:
  ```bash
  ansible --version
  ```

### 2. Configure Ansible Inventory
- Open the Ansible inventory file using:
  ```bash
  vim /etc/ansible/hosts
  ```
- Added a new group `webservers` and defined the managed hosts.

### 3. Verify Connectivity with Ping Command
- Ran the following command to test connectivity between the control node and managed hosts:
  ```bash
  ansible webservers -m ping
  ```
- Successfully received a `pong` response from all configured servers, indicating that Ansible is properly set up and can communicate with the managed nodes.

## Verification
The output confirmed the successful execution of the `ping` module, displaying responses from all servers in the `webservers` group.

## Screenshots
### 1. Editing Ansible Inventory
![Editing Inventory](./screenshots/edit_inventory1.png)
![Editing Inventory](./screenshots/edit_inventory2.png)


### 2. Successful Ping Test
![Ping Test](./screenshots/ping_test.png)

## Conclusion
Ansible has been successfully set up, and the control node can communicate with the managed hosts. This setup allows for automated administration and deployment tasks across multiple servers.

