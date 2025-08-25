#!/bin/bash
# DIANA STORE VPN PANEL – ONE FILE
set -e
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
[[ $EUID -ne 0 ]] && { echo -e "${RED}Harus root!${NC}"; exit 1; }

# 1. Dependensi + Xray
echo -e "${YELLOW}Install dependensi...${NC}"
apt update && apt install -y curl unzip nginx uuid-runtime certbot python3-certbot-nginx jq
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install

# 2. Domain
read -p "Masukkan domain kamu: " DOMAIN
[[ -z "$DOMAIN" ]] && { echo -e "${RED}Domain kosong!${NC}"; exit 1; }

# 3. Folder & file
mkdir -p /etc/diana/users
echo "$DOMAIN" > /etc/diana/domain
echo "$(curl -s ifconfig.me)" > /etc/diana/ip

# 4. Nginx 80 → Certbot
cat > /etc/nginx/sites-available/xray <<EOF
server {
    listen 80;
    server_name $DOMAIN;
    location /.well-known/acme-challenge/ { root /var/www/html; }
}
EOF
ln -sf /etc/nginx/sites-available/xray /etc/nginx/sites-enabled/
nginx -t && systemctl restart nginx
certbot --nginx -d $DOMAIN --agree-tos --email admin@$DOMAIN --no-eff-email --redirect

# 5. Xray WS + TLS
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": 10085, "listen": "127.0.0.1", "protocol": "vless",
      "settings": { "clients": [] },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "/vless" }, "security": "none" }
    },
    {
      "port": 10086, "listen": "127.0.0.1", "protocol": "vmess",
      "settings": { "clients": [] },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "/vmess" }, "security": "none" }
    },
    {
      "port": 10087, "listen": "127.0.0.1", "protocol": "trojan",
      "settings": { "clients": [] },
      "streamSettings": { "network": "ws", "wsSettings": { "path": "/trojan" }, "security": "none" }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF
systemctl restart xray

# 6. SEMUA FUNGSI DALAM 1 FILE
cat > /etc/diana/menu <<'MENU'
#!/bin/bash
menu_header() {
clear
echo -e "\e[1;36m╔════════════════════════════════════╗
║   DIANA STORE VPN PANEL v2.0       ║
╚════════════════════════════════════╝\e[0m"
echo -e "\e[1;33mOS  :\e[0m $(lsb_release -d | awk -F: '{print $2}' | xargs)"
echo -e "\e[1;33mRAM :\e[0m $(free -m | awk 'NR==2{printf "%.0fMB", $2}')"
echo -e "\e[1;33mIP  :\e[0m $(cat /etc/diana/ip)"
echo -e "\e[1;33mDomain :\e[0m $(cat /etc/diana/domain)"
echo -e "\e[1;33m══════════════════════════════════════\e[0m"
}
while true; do
menu_header
echo -e "\e[1;36m[1] VMess Menu"
echo -e "\e[1;36m[2] VLESS Menu"
echo -e "\e[1;36m[3] Trojan Menu"
echo -e "\e[1;36m[8] Lihat Semua User"
echo -e "\e[1;36m[0] Keluar"
echo -e "\e[1;33m══════════════════════════════════════\e[0m"
read -p "Pilih : " p
case $p in
1) proto=vmess port=10086 path=/vmess ;;
2) proto=vless port=10085 path=/vless ;;
3) proto=trojan port=10087 path=/trojan ;;
8) echo -e "\e[1;33mSSH :"; awk -F: '$3>=1000&&$3<60000{print $1}' /etc/passwd; echo; \
   for f in vmess vless trojan; do echo -e "\e[1;33m${f^^} :"; cat /etc/diana/users/${f}.txt 2>/dev/null; echo; done; read -n1 -r ;;
0) exit ;;
*) echo "Pilihan tidak tersedia"; sleep 2; continue ;;
esac
# Sub-menu
clear
echo -e "\e[1;36m╔══════════════ ${proto^^} Menu ══════════════╗\e[0m"
echo -e "\e[1;36m[1] Buat Akun"
echo -e "\e[1;36m[2] Trial 1 jam"
echo -e "\e[1;36m[3] Cek Aktif"
echo -e "\e[1;36m[4] Hapus User"
echo -e "\e[1;36m[0] Kembali"
echo -e "\e[1;36m╚════════════════════════════════════════╝\e[0m"
read -p "Pilih : " sp
DOMAIN=$(cat /etc/diana/domain)
case $sp in
1) read -p "Nama : " n; read -p "Hari : " h; uuid=$(cat /proc/sys/kernel/random/uuid); \
   expiry=$(date -d "+$h days" +%Y-%m-%d); \
   echo "$n:$uuid:$expiry" >> /etc/diana/users/${proto}.txt; \
   echo -e "\e[1;32m╔════════════════════════════════════════════╗\e[0m"; \
   echo -e " Domain : $DOMAIN\n Port   : 443\n User   : $n\n Exp    : $expiry"; \
   [[ "$proto" == "vmess" ]] && \
   echo -e " VMess TLS: vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"$n\",\"add\":\"$DOMAIN\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$DOMAIN\",\"path\":\"$path\",\"tls\":\"tls\"}" | base64 -w 0)" || \
   echo -e " ${proto^^} TLS: ${proto}://${uuid}@${DOMAIN}:443?type=ws&security=tls&path=${path}#${n}"; \
   echo -e "\e[1;32m╚════════════════════════════════════════════╝\e[0m"; read -n1 ;;
2) n="trial-$(date +%s)"; uuid=$(cat /proc/sys/kernel/random/uuid); \
   expiry=$(date -d "+1 hour" +%Y-%m-%d\ %H:%M); \
   echo "$n:$uuid:$expiry" >> /etc/diana/users/${proto}.txt; echo "Trial $proto $n 1 jam dibuat."; sleep 2 ;;
3) cat /etc/diana/users/${proto}.txt; read -n1 ;;
4) read -p "Nama user yang dihapus : " del; sed -i "/^$del:/d" /etc/diana/users/${proto}.txt; echo "User $del dihapus."; sleep 2 ;;
0) continue ;;
esac
done
MENU
chmod +x /etc/diana/menu

# 7. Alias biar cukup ketik "diana"
echo 'alias diana="bash /etc/diana/menu"' >> ~/.bashrc
source ~/.bashrc

echo -e "${GREEN}✅ SELESAI! Ketik 'diana' di mana saja untuk menjalankan menu.${NC}"
