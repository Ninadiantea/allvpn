#!/bin/bash
# DIANA STORE VPN PANEL v1.0
clear
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
echo -e "${YELLOW}Installing DIANA STORE VPN PANEL...${NC}"
apt update && apt install curl wget unzip nginx uuid-runtime certbot python3-certbot-nginx -y
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
mkdir -p /etc/diana
echo "128.199.84.230" > /etc/diana/ip
echo "premium.vpshuman.xyz" > /etc/diana/domain
systemctl restart nginx
systemctl restart xray
echo -e "${GREEN}✅ DIANA STORE VPN PANEL installed!${NC}"
