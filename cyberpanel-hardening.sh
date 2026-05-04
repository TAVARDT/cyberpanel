#!/bin/bash
# ----------------------------------------------------------------------
# TAVARDT Elite CyberPanel Hardening Script
# ----------------------------------------------------------------------
# Description: Secures a fresh CyberPanel installation by altering the 
# default SSH port, restricting panel access, and enforcing PHP limits.
# 
# Run as: root
# ----------------------------------------------------------------------

echo "[TAVARDT] Starting CyberPanel Infrastructure Hardening..."

# 1. SSH Hardening
# Change default SSH port from 22 to a random high port (e.g., 55922)
# Disable Root Login directly via SSH
NEW_SSH_PORT=55922
SSH_CONF="/etc/ssh/sshd_config"

echo "Hardening SSH access..."
sed -i "s/#Port 22/Port $NEW_SSH_PORT/" $SSH_CONF
sed -i "s/Port 22/Port $NEW_SSH_PORT/" $SSH_CONF
sed -i "s/PermitRootLogin yes/PermitRootLogin prohibit-password/" $SSH_CONF
sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin prohibit-password/" $SSH_CONF

# Restart SSH Service safely
systemctl restart sshd || systemctl restart ssh

# 2. Firewall Tuning (UFW/CSF)
# Ensure the new SSH port is open before we lock ourselves out!
echo "Configuring Firewall..."
if command -v ufw > /dev/null; then
    ufw allow $NEW_SSH_PORT/tcp
    ufw allow 80/tcp
    ufw allow 443/tcp
    # Optional: Restrict port 8090 (CyberPanel Admin) to your agency's Office IP only
    # ufw allow from 123.456.789.0/24 to any port 8090
    ufw reload
elif command -v csf > /dev/null; then
    sed -i "s/TCP_IN = \"/TCP_IN = \"$NEW_SSH_PORT,/" /etc/csf/csf.conf
    csf -r
fi

# 3. PHP Default Limits (lsphp)
# CyberPanel often leaves default PHP limits too low for enterprise WP/Magento,
# or too high without execution time limits (causing CPU hangs).
echo "Securing PHP (lsphp) limits..."

for v in 74 80 81 82 83; do
    INI_FILE="/usr/local/lsws/lsphp$v/etc/php.ini"
    if [ -f "$INI_FILE" ]; then
        sed -i 's/memory_limit = .*/memory_limit = 512M/' $INI_FILE
        sed -i 's/max_execution_time = .*/max_execution_time = 120/' $INI_FILE
        sed -i 's/upload_max_filesize = .*/upload_max_filesize = 128M/' $INI_FILE
        sed -i 's/post_max_size = .*/post_max_size = 128M/' $INI_FILE
        sed -i 's/expose_php = On/expose_php = Off/' $INI_FILE # Security: Hide PHP version
    fi
done

# Restart PHP processes
killall lsphp

echo "[TAVARDT] Hardening Complete. IMPORTANT: Your new SSH Port is $NEW_SSH_PORT."
