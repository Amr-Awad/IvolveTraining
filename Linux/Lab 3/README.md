# Ping Subnet Script

## Overview
This script scans the local subnet (`s.s.s.x`, where `x = 0 to 255`) and checks which servers are reachable. It dynamically detects the current IP and pings every possible IP in the subnet, printing whether each server is **up** or **unreachable**.

## What This Script Does
- Detects the machine’s current IP address.
- Extracts the first three octets (`s.s.s`).
- Pings all `x` values from `0` to `255`.
- Prints the status of each IP (`up and running` or `unreachable`).

## Prerequisites
- A Linux system (Tested on RHEL 9.3).
- A user with basic shell privileges.

## Script Usage
1. **Make the script executable:**  
   ```bash
   chmod +x ./ping_subnet.sh
   ```
2. **Run the script:**  
   ```bash
   ./ping_subnet.sh
   ```  

## Verification
After running the script, you should see output like this:
```
Scanning network: 172.25.250.x (where x = 0 to 255)...
Server 172.25.250.1 is unreachable
Server 172.25.250.9 is up and running
Server 172.25.250.10 is up and running
Server 172.25.250.11 is up and running
...
```

## Screenshots
### **1. Script Execution Output**
![Script Output](./screenshots/ping_subnet_output.png)

## Conclusion
This script automates network scanning within the local subnet, helping detect active and inactive servers. It is useful for troubleshooting and network diagnostics.

