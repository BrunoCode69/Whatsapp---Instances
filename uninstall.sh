#!/bin/bash
systemctl stop manange_users
systemctl disable manange_users
rm -f /etc/systemd/system/manange_users.service
rm -f /bin/manange_users
systemctl daemon-reload
rm -r uninstall.sh