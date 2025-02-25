#!/bin/bash
tail -F /var/log/gemini.log | while read line; do
    echo "$line" | nc 172.20.241.20 18736
done