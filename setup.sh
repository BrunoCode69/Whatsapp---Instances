#!/bin/bash
port=$1
api_key=$2
ARCH=$(uname -m)

mkdir /bin/manage_users

BASE_URL="https://github.com/BrunoCode69/Whatsapp---Instances/raw/main"

if [[ "$ARCH" == "x86_64" ]]; then
    FILE="index_x86"
elif [[ "$ARCH" == "aarch64" || "$ARCH" == "armv7l" ]]; then
    FILE="index_arm"
else
    echo "Arquitetura não suportada: $ARCH"
    exit 1
fi

wget -O /bin/manage_users/index "$BASE_URL/$FILE" > /dev/null 2>&1

chmod +x /bin/manage_users/index

echo "[Unit]
Description=Manage Users Service
After=network.target

[Service]
ExecStart=/bin/manage_users/index $port $api_key
WorkingDirectory=/bin/manage_users/
Restart=always

Environment=NODE_ENV=production
StandardOutput=append:/var/log/manage_users.log
StandardError=append:/var/log/manage_users.log

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/manage_users.service

systemctl daemon-reload > /dev/null 2>&1
systemctl enable manage_users.service > /dev/null 2>&1
systemctl start manage_users.service > /dev/null 2>&1
