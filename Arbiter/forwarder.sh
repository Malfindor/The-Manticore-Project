#!/bin/bash

while true; do
	log=$(nc -l -p 18736)
	echo "$log" >> /var/Arbiter/buffer.log
done