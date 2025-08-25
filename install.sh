#!/bin/bash
# DIANA STORE VPN PANEL v2.0
set -e
clear
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'

echo -e "${YELLOW}DIANA STORE VPN PANEL - Installer${NC}"

apt update && apt install -y curl wget unzip nginx uuid-runtime certbot python3-certbot-nginx jq

# Minta domain
read -p "Masukkan domain kamu (contoh: vpn.anda.com): " DOMAIN
[ -z "$DOMAIN" ] && { echo -e "${RED}Domain tidak boleh kosong!${NC}"; exit 1; }

# Install Xray
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# Folder & file persiapan
mkdir -p /etc/diana/users
echo "$DOMAIN" > /etc/diana/domain
echo "$(curl -s ifconfig.me)" > /etc/diana/ip

# Konfigurasi Nginx
cat > /etc/nginx/sites-available/diana <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    location / { return 301 https://\$host\$request_uri; }
    location /.well-known/acme-challenge/ { root /var/www/html; }
}
server {
    listen 443 ssl http2;
    server_name $DOMAIN;
    ssl_certificate /etc/letsencrypt/live/$DOMAIN/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/$DOMAIN/privkey.pem;

    location /vless {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10085;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
    location /vmess {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10086;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
    location /trojan {
        proxy_redirect off;
        proxy_pass http://127.0.0.1:10087;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host \$host;
    }
}
EOF
ln -sf /etc/nginx/sites-available/diana /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx

# SSL otomatis
certbot --nginx -d $DOMAIN --agree-tos --email admin@$DOMAIN --no-eff-email --redirect

# Konfigurasi Xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 10085,
      "listen": "127.0.0.1",
      "protocol": "vless",
      "settings": { "clients": [] },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/vless" },
        "security": "none"
      }
    },
    {
      "port": 10086,
      "listen": "127.0.0.1",
      "protocol": "vmess",
      "settings": { "clients": [] },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/vmess" },
        "security": "none"
      }
    },
    {
      "port": 10087,
      "listen": "127.0.0.1",
      "protocol": "trojan",
      "settings": { "clients": [] },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/trojan" },
        "security": "none"
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF
systemctl restart xray

# Download script pendukung
for f in menu.sh user-add-ssh.sh user-add-vmess.sh user-add-vless.sh user-add-trojan.sh user-list.sh; do
    curl -s https://raw.githubusercontent.com/Ninadiantea/allvpn/main/$f -o /etc/diana/$f
    chmod +x /etc/diana/$f
done

echo -e "${GREEN}✅ Install selesai! Jalankan menu:${NC}"
echo "  bash /etc/diana/menu.sh"
