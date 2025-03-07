#!/bin/bash
inotifywait -m -e modify /etc/sysconfig/iptables /etc/iptables/rules.v4 |
while read path action file; do
    current_time=$(date +"%H:%M:%S")
	log="[ $current_time ] - Changes to iptables was detected"
	echo $log >> /var/log/gemini.log
done