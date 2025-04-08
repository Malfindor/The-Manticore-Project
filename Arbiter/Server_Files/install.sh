#!/bin/bash
repo_root=$(git rev-parse --show-toplevel)
mkdir /opt/arbiter
mkdir /opt/arbiter/configs
mkdir /opt/arbiter/bin
mkdir /var/log/arbiter
mkdir /var/log/arbiterHistory
touch /var/arbiter/connections.log
touch /var/log/masterArbiter.log
mv $repo_root/scripts/linux/Arbiter/Server_Files/listener.conf /opt/arbiter/configs/listener.conf
mv $repo_root/scripts/linux/Arbiter/Server_Files/terminal.py /bin/arbiter
chmod +x /bin/arbiter