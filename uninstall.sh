#!/bin/bash
systemctl stop manage_users > /dev/null 2>&1
systemctl disable manage_users > /dev/null 2>&1
rm -f /etc/systemd/system/manage_users.service > /dev/null 2>&1
rm -r /bin/manage_users > /dev/null 2>&1
systemctl daemon-reload > /dev/null 2>&1
