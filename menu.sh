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
echo -e "\e[1;33mIP VPS\e[0m: $(cat /etc/diana/ip)"
echo -e "\e[1;33mDomain\e[0m: $(cat /etc/diana/domain)"
echo ""
echo -e "\e[1;36m[01] Buat SSH        [11] Speedtest"
echo -e "[02] Buat VMess      [12] Status Service"
echo -e "[03] Buat VLESS      [13] Hapus Log"
echo -e "[04] Buat Trojan     [16] Reboot"
echo -e "[08] Lihat Semua User"
echo -e "[00] Keluar"
echo ""
read -p "Pilih menu: " menu
case $menu in
1) /etc/diana/user-add-ssh.sh ;;
2) /etc/diana/user-add-vmess.sh ;;
3) /etc/diana/user-add-vless.sh ;;
4) /etc/diana/user-add-trojan.sh ;;
8) /etc/diana/user-list.sh ;;
11) curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 ;;
12) systemctl status ssh nginx xray ;;
13) echo "" > /var/log/syslog ;;
16) reboot ;;
0|00) exit ;;
*) echo "Pilihan tidak tersedia"; sleep 2 ;;
esac
done
