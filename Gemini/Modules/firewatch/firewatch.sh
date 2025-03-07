#!/bin/bash
iptables -L -v -n > /tmp/iptables_old
while true; do
    iptables -L -v -n > /tmp/iptables_new
    if ! diff /tmp/iptables_old /tmp/iptables_new > /dev/null; then
        current_time=$(date +"%H:%M:%S")
		log="[ $current_time ] - Changes to iptables were detected."
		echo $log >> /var/log/gemini.log
    fi
    sleep 5
done