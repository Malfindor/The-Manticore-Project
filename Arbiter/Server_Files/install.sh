#!/bin/bash
repo_root=$(git rev-parse --show-toplevel)
touch /var/Arbiter/buffer.log
touch /var/Arbiter/read.log
touch /var/Arbiter/active.log
touch /var/log/masterArbiter.log
mv $repo_root/scripts/linux/Arbiter/terminal.py /bin/arbiter
chmod +x /bin/arbiter