import subprocess
import re

# Load trusted IPs
with open("trusted_ips.txt") as f:
    whitelist = set(line.strip() for line in f if line.strip())

# Run 'who' and capture the output
who_output = subprocess.check_output(['who'], text=True)

for line in who_output.strip().split('\n'):
    # Use regex to extract fields
    match = re.match(r'(\S+)\s+(\S+)\s+\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}\s+\(([\d\.]+)\)', line)
    if not match:
        continue

    user, tty, ip = match.groups()

    if ip not in whitelist:
        print(f"[!] Unauthorized user detected: {user} from {ip}")

        # Kick the user
        try:
            subprocess.run(['pkill', '-KILL', '-u', user], check=True)
        except subprocess.CalledProcessError:
            print(f"[x] Failed to kick user: {user}")

        # Block IP with iptables
        try:
            subprocess.run(['iptables', '-A', 'INPUT', '-s', ip, '-j', 'DROP'], check=True)
        except subprocess.CalledProcessError:
            print(f"[x] Failed to block IP: {ip}")

        print(f"[+] User {user} kicked and locked. IP {ip} blocked.")
