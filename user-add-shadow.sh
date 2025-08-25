#!/bin/bash
read -p "Nama Shadow: " name
read -p "Password: " pass
read -p "Masa aktif (hari): " exp
domain=$(cat /etc/diana/domain)
expiry=$(date -d "+$exp days" +%Y-%m-%d)
echo "$name:$pass:$expiry" >> /etc/diana/users/shadow.txt
echo "Shadow created: $name | Pass: $pass | Exp: $expiry"
