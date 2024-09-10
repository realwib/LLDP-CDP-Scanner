#!/bin/bash

# Filename: network_scan_continuous.sh

# Default settings
LLDP_LOGFILE="lldp_info.log"
CDP_LOGFILE="cdp_info.log"
SCAN_INTERVAL=60
INTERFACE="eth0"

# Parse command-line arguments for log files, scan interval, and interface
while getopts "l:c:i:n:" opt; do
    case $opt in
        l) LLDP_LOGFILE=$OPTARG ;;
        c) CDP_LOGFILE=$OPTARG ;;
        i) SCAN_INTERVAL=$OPTARG ;;
        n) INTERFACE=$OPTARG ;;
        *) echo "Usage: $0 [-l lldp_log_file] [-c cdp_log_file] [-i scan_interval] [-n network_interface]"; exit 1 ;;
    esac
done

# Ensure lldpd is running
if ! sudo systemctl is-active --quiet lldpd; then
    echo "Starting lldpd service..."
    sudo systemctl start lldpd
    if [ $? -ne 0 ]; then
        echo "Failed to start lldpd service. Exiting."
        exit 1
    fi
fi

# Ensure cdpr is installed
if ! command -v cdpr &> /dev/null; then
    echo "cdpr is not installed. Please install it first."
    exit 1
fi

# Infinite loop to continuously scan
while true; do
    # LLDP Scan
    lldpctl_output=$(sudo lldpctl 2>/dev/null)
    if [ -z "$lldpctl_output" ]; then
        echo "No LLDP information found. Ensure LLDP is enabled on your network devices."
    else
        echo "----- LLDP Scan at $(date) -----" >> "$LLDP_LOGFILE"
        echo "$lldpctl_output" >> "$LLDP_LOGFILE"
        echo "--------------------------------" >> "$LLDP_LOGFILE"
        echo "LLDP information appended to $LLDP_LOGFILE"
    fi

    # CDP Scan
    cdpr_output=$(sudo cdpr -d "$INTERFACE" 2>/dev/null)
    if [[ $cdpr_output == *"No CDP packets received"* ]]; then
        echo "No CDP information found. Ensure CDP is enabled on your network devices."
    else
        echo "----- CDP Scan at $(date) -----" >> "$CDP_LOGFILE"
        echo "$cdpr_output" >> "$CDP_LOGFILE"
        echo "--------------------------------" >> "$CDP_LOGFILE"
        echo "CDP information appended to $CDP_LOGFILE"
    fi

    # Wait for the specified interval before the next scan
    sleep "$SCAN_INTERVAL"
done
