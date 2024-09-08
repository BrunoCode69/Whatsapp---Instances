#!/bin/bash

for user in $(grep -v '^root:' /etc/passwd | grep '/bin/false' | cut -d: -f1); do
    sudo userdel -r "$user"
done
