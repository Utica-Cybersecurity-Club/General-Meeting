#!/bin/bash

# Load trusted IPs
mapfile -t WHITELIST < trusted_ips.txt

# Check logged in users
who | while read user tty date time ip_raw; do
    ip="${ip_raw//[\(\)]/}"  # Remove parentheses

    # Check if IP is in whitelist
    if [[ ! " ${WHITELIST[@]} " =~ " ${ip} " ]]; then
        echo "[!] Unauthorized user detected: $user from $ip"

        # Kick the user
        pkill -KILL -u "$user"
        
        # Optional: Add firewall block
        iptables -A INPUT -s "$ip" -j DROP

        echo "[+] User $user kicked and locked. IP $ip blocked."
    fi
done
