#!/bin/bash
systemctl stop manage_users
systemctl disable manage_users
rm -f /etc/systemd/system/manage_users.service
rm -r /bin/manage_users
systemctl daemon-reload
rm -r uninstall.sh
