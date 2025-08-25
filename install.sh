#!/bin/bash
# DIANA STORE VPN PANEL v1.0
clear
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Installing DIANA STORE VPN PANEL...${NC}"

apt update && apt install curl wget unzip nginx uuid-runtime certbot python3-certbot-nginx jq -y

# Minta domain
read -p "Masukkan domain kamu (contoh: vpn.anda.com): " DOMAIN
if [[ -z "$DOMAIN" ]]; then
    echo -e "${RED}Domain tidak boleh kosong!${NC}"
    exit 1
fi

# Install Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# Buat folder & simpan domain
mkdir -p /etc/diana /etc/diana/users
echo "$DOMAIN" > /etc/diana/domain
echo "$(curl -s ifconfig.me)" > /etc/diana/ip

# Setup Nginx & SSL
cat > /etc/nginx/sites-available/diana <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    location / {
        return 301 https://\$host\$request_uri;
    }
    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }
}
EOF
ln -sf /etc/nginx/sites-available/diana /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# SSL otomatis
certbot --nginx -d $DOMAIN --agree-tos --email admin@$DOMAIN --no-eff-email --redirect

# Restart
systemctl restart xray
echo -e "${GREEN}✅ DIANA STORE VPN PANEL installed dengan domain: $DOMAIN${NC}"
