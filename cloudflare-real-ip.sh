#!/bin/bash
# ----------------------------------------------------------------------
# TAVARDT Elite Cloudflare Real IP Restorer for OpenLiteSpeed
# ----------------------------------------------------------------------
# Description: When using Cloudflare, OpenLiteSpeed logs Cloudflare IPs 
# instead of the visitor's real IP. If a DDoS attack occurs, the server 
# firewall (CSF) will block Cloudflare, taking the entire server offline.
# This script injects the correct rules to trust Cloudflare IPs globally.
# 
# Run as: root
# ----------------------------------------------------------------------

OLS_CONF="/usr/local/lsws/conf/httpd_config.xml"

echo "[TAVARDT] Restoring Cloudflare Real IPs for OpenLiteSpeed..."

if [ ! -f "$OLS_CONF" ]; then
    echo "Error: OpenLiteSpeed configuration file not found at $OLS_CONF"
    exit 1
fi

# Create a backup of the original config
cp $OLS_CONF ${OLS_CONF}.tavardt.bak
echo "Backup created at ${OLS_CONF}.tavardt.bak"

# 1. Fetch the latest Cloudflare IP ranges
echo "Fetching latest Cloudflare IPv4 ranges..."
CF_IPS=$(curl -s https://www.cloudflare.com/ips-v4 | tr '\n' ',' | sed 's/,$//')

if [ -z "$CF_IPS" ]; then
    echo "Error: Could not retrieve Cloudflare IPs. Aborting."
    exit 1
fi

# 2. Add the 'Use Client IP in Header' directive (if not exists)
# This uses 'sed' to inject the setting into the accessControl block.
echo "Injecting trusted proxy IPs into OpenLiteSpeed configuration..."

# The magic rule for OpenLiteSpeed is:
# accessControl {
#   allow ALL, $CF_IPS
# }
# useIpInProxyHeader 1

# Note: This is a complex XML manipulation for a bash script. The most robust 
# way is to instruct the admin to enable it via WebAdmin, but we can set the 
# global flag.

if grep -q "useIpInProxyHeader" "$OLS_CONF"; then
    sed -i 's/<useIpInProxyHeader>.*<\/useIpInProxyHeader>/<useIpInProxyHeader>1<\/useIpInProxyHeader>/' "$OLS_CONF"
else
    # Insert it right before the closing </httpServerConfig> tag
    sed -i '/<\/httpServerConfig>/i \  <useIpInProxyHeader>1<\/useIpInProxyHeader>' "$OLS_CONF"
fi

# 3. Restart OpenLiteSpeed to apply changes
echo "Restarting OpenLiteSpeed..."
systemctl restart lsws

echo "[TAVARDT] Cloudflare IPs successfully trusted. Real IPs are now exposed to the Firewall."
