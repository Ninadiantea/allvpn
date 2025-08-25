#!/bin/bash
read -p "Nama VLESS: " name
read -p "Masa aktif (hari): " exp
uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /etc/diana/domain)
expiry=$(date -d "+$exp days" +%Y-%m-%d)
echo "$name:$uuid:$expiry" >> /etc/diana/users/vless.txt
echo "VLESS created: $name | UUID: $uuid | Exp: $expiry"
echo "Link: vless://$uuid@$domain:443?type=ws&security=tls&path=/vless#$name"
