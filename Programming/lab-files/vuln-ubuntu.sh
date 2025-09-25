#!/bin/bash

# Vulnerable Lab Setup Script for Ubuntu 18.04 but works, partially, on other Ubuntu Versions
# For educational use ONLY in isolated lab environments

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "[!] This script must be run as root or with sudo." >&2
  exit 1
fi

# Installing Services
set -e

echo "[*] Updating system..."
apt update && apt upgrade -y

echo "[*] Installing services and dependencies..."
apt install -y openssh-server apache2 mysql-server php php-mysql libapache2-mod-php \
    vsftpd curl wget unzip sudo cron git

echo "[*] Enabling SSH password authentication..."
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd

echo "[*] Creating users..."

# Weak users
useradd -m user1
echo 'user1:password' | chpasswd

useradd -m user2
echo 'user2:123456' | chpasswd

# Sudo user with no password
useradd -m admin
echo 'admin:admin123' | chpasswd
usermod -aG sudo admin
echo 'admin ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/admin

# Lazyadmin with limited but exploitable sudo
useradd -m lazyadmin
echo 'lazyadmin:lazy123' | chpasswd
echo 'lazyadmin ALL=(ALL) NOPASSWD: /usr/bin/vim' > /etc/sudoers.d/lazyadmin

echo "[*] Setting up MySQL with insecure root access..."
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
mysql -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
FLUSH PRIVILEGES;
EOF

echo "[*] Configuring VSFTPD with anonymous access..."
cat <<EOF > /etc/vsftpd.conf
listen=YES
anonymous_enable=YES
local_enable=YES
write_enable=YES
chroot_local_user=YES
allow_writeable_chroot=YES
EOF
systemctl restart vsftpd

echo "[*] Disabling UFW firewall and AppArmor..."
ufw disable || true
systemctl stop apparmor || true
systemctl disable apparmor || true

echo "[*] Adding dangerous PHP web shell..."
echo '<?php echo shell_exec($_GET["cmd"]); ?>' > /var/www/html/shell.php
chmod 777 /var/www/html/shell.php

echo "[*] Adding vulnerable cronjob for privilege escalation..."

mkdir -p /opt/cronstuff
echo -e '#!/bin/bash\ncp /bin/bash /tmp/rootbash\nchmod +s /tmp/rootbash' > /opt/cronstuff/root.sh
chmod +x /opt/cronstuff/root.sh
chown root:root /opt/cronstuff/root.sh
chmod 777 /opt/cronstuff/root.sh  # writable by anyone (deliberate misconfig)

# Add cronjob as root
echo "* * * * * root /opt/cronstuff/root.sh" > /etc/cron.d/rootjob
chmod 644 /etc/cron.d/rootjob

echo "[*] Installing known-vulnerable WordPress (v4.7.0)..."

cd /tmp
wget https://wordpress.org/wordpress-4.7.0.tar.gz
tar -xzf wordpress-4.7.0.tar.gz
mv wordpress /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress

# Create database for WP
mysql -uroot -proot <<EOF
CREATE DATABASE wp;
GRANT ALL PRIVILEGES ON wp.* TO 'wpuser'@'localhost' IDENTIFIED BY 'wppass';
FLUSH PRIVILEGES;
EOF

# Configure wp-config.php
cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/wp/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/wpuser/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/wppass/" /var/www/html/wordpress/wp-config.php

echo "[*] Restarting services..."
systemctl restart apache2
systemctl restart cron

echo "[*] Done. REBOOT recommended before snapshot."
