#!/bin/bash
LISTEN_PORT=18965
processCommand() # Usage: processCommand {command}
{
	IS_PREDEFINED_CMD=$false
	input="$1"
	
	IFS="-" read -ra inputSplit <<< "$input"
	case "${inputSplit[0]}" in
	"B45")
		#Blacklist IP found in "${inputSplit[1]}"
	;;
	*)
	;;
	esac
}
while true; do
	recievedMsg="$(nc -l -p $LISTEN_PORT)"
	processCommand "$recievedMsg"
	if ! $IS_PREDEFINED_CMD; then
		#Code to process playbook input
	fi
done