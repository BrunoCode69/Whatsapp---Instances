#!/bin/bash
port=$1;

mkdir /bin/manage_users
wget -P /bin/manage_users/ https://github.com/BrunoCode69/Whatsapp---Instances/raw/main/index > /dev/null 2>&1
chmod +x /bin/manage_users/index

echo "[Unit]
Description=Manage Users Service
After=network.target

[Service]
ExecStart=/bin/manage_users/index $port
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
cat /var/log/manage_users.log