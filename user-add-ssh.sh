#!/bin/bash
read -p "Username SSH: " user
read -p "Password SSH: " pass
read -p "Masa aktif (hari): " exp
useradd -e $(date -d "+$exp days" +%Y-%m-%d) -s /bin/false "$user"
echo "$user:$pass" | chpasswd
echo "SSH User: $user | Pass: $pass | Exp: $(date -d "+$exp days")"
