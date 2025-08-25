#!/bin/bash
read -p "Nama Trojan: " name
read -p "Masa aktif (hari): " exp
uuid=$(cat /proc/sys/kernel/random/uuid)
domain=$(cat /etc/diana/domain)
expiry=$(date -d "+$exp days" +%Y-%m-%d)
echo "$name:$uuid:$expiry" >> /etc/diana/users/trojan.txt
echo "✅ Trojan user: $name | Pass: $uuid | Exp: $expiry"
echo "Link:"
echo "trojan://$uuid@$domain:443?security=tls&type=ws&path=/trojan#$name"
