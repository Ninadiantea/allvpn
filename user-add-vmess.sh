#!/bin/bash
read -p "Nama VMess: " name
read -p "Masa aktif (hari): " exp
uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /etc/diana/domain)
expiry=$(date -d "+$exp days" +%Y-%m-%d)
echo "$name:$uuid:$expiry" >> /etc/diana/users/vmess.txt
echo "VMess created: $name | UUID: $uuid | Exp: $expiry"
echo "Link: vmess://$(echo -n "{\"v\":\"2\",\"ps\":\"$name\",\"add\":\"$domain\",\"port\":\"443\",\"id\":\"$uuid\",\"aid\":\"0\",\"net\":\"ws\",\"type\":\"none\",\"host\":\"$domain\",\"path\":\"/vmess\",\"tls\":\"tls\"}" | base64 -w 0)"
