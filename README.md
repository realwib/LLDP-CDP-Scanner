# Network Scanner using LLDP & CDP Protocol

This repository contains a script for continuous network scanning using LLDP and CDP protocols. 

## Description

The `network_scan_continuous.sh` script performs continuous scans of network devices using LLDP (Link Layer Discovery Protocol) and CDP (Cisco Discovery Protocol). It logs the information to separate files with timestamps.

## Features

- Continuous scanning of network devices.
- Logs LLDP and CDP information to separate files.
- Configurable scan interval and network interface.

## Usage

1. **Clone the repository:**

    ```bash
    git clone https://github.com/realwib/LLDP-CDP-Scanner.git
    cd LLDP-CDP-Scanner
    ```

2. **Make the script executable:**

    ```bash
    chmod +x network_scan_continuous.sh
    ```

3. **Run the script:**

    ```bash
    ./network_scan_continuous.sh -l lldp_info.log -c cdp_info.log -i 60 -n eth0
    ```

    **Options:**
    - `-l` Specify the LLDP log file.
    - `-c` Specify the CDP log file.
    - `-i` Specify the scan interval in seconds.
    - `-n` Specify the network interface for CDP scanning.

## Requirements

- `lldpd` service must be installed and running.
- `cdpr` must be installed.
- `sudo` privileges are required.

