#!/bin/bash
while true; do
clear
echo -e "\e[1;36m
 ██▓███   ██▓ ██▓███ ▓█████  ██▀███
▓██░  ██▒▓██▒▓██░  ██▒▓█   ▀ ▓██ ▒ ██▒
▓██░ ██▓▒▒██▒▓██░ ██▓▒▒███   ▓██ ░▄█ ▒
▒██▄█▓▒ ▒░██░▒██▄█▓▒ ▒▒▓█  ▄ ▒██▀▀█▄
▒██▒ ░  ░░██░▒██▒ ░  ░░▒████▒░██▓ ▒██▒
▒▓▒░ ░  ░░▓  ▒▓▒░ ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░
░▒ ░      ▒ ░░▒ ░      ░ ░  ░  ░▒ ░ ▒░
░░        ▒ ░░░          ░     ░░   ░
          ░              ░  ░   ░
\e[0m"
echo -e " \e[1;32mWELCOME TO DIANA STORE VPN PANEL\e[0m"
echo ""
echo -e "\e[1;33mSystem OS\e[0m: $(lsb_release -d | awk -F: '{print $2}' | xargs)"
echo -e "\e[1;33mServer RAM\e[0m: $(free -m | awk 'NR==2{printf "%.0fMB", $2}')"
echo -e "\e[1;33mUptime\e[0m: $(uptime -p)"
echo -e "\e[1;33mIP VPS\e[0m: $(curl -s ifconfig.me)"
echo -e "\e[1;33mDomain\e[0m: $(cat /etc/diana/domain 2>/dev/null || echo 'Belum di-set')"
echo ""
echo -e "\e[1;36m[01] SSH Menu          [11] Speedtest"
echo -e "[02] VMESS Menu        [12] Running Service"
echo -e "[03] VLESS Menu        [13] Clear Log"
echo -e "[04] TROJAN Menu       [14] Create SlowDNS"
echo -e "[05] SHADOW Menu       [15] Backup/Restore"
echo -e "[06] Trial Menu        [16] Reboot"
echo -e "[07] VPS Info          [17] Restart Service"
echo -e "[08] Delete All Exp    [18] Change Domain"
echo -e "[09] Auto Reboot       [19] Cert SSL"
echo -e "[10] Info Port         [20] Update Script"
echo ""
read -p "Select menu [1-20]: " menu
done
