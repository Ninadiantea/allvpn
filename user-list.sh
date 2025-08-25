#!/bin/bash
echo "=== SSH ==="
awk -F: '$3>=1000 && $3<60000 {print $1}' /etc/passwd
echo ""
echo "=== VMess ==="
cat /etc/diana/users/vmess.txt
echo ""
echo "=== VLESS ==="
cat /etc/diana/users/vless.txt
echo ""
echo "=== Trojan ==="
cat /etc/diana/users/trojan.txt
