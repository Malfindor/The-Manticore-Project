#!/bin/bash
processConfFile()
{
	mapfile -t confList < "/etc/manticore/listener.conf"
	for line in "${confList[@]}"; do
		if ! [[ "${line:0:1}" == "#" ]]; then
			IFS="=" read -ra lineSplit <<< "$line"
			case "${lineSplit[0]}" in
				*)
					;;
			esac
		fi
	done
}