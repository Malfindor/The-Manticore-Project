#!/bin/bash
printHelp()
{
	echo "
Gemini - System integrity application

Usage:
		
		gemini start - Starts up gemini services
		gemini stop - Shuts down gemini services
		
Arguments:

		-v   |   Verifies integrity of gemini system files

"
}
verifyRunning()
{
	local module="$1"
	isRunning=$false
	systemctl is-active --quiet $module && service_running=$true || service_running=$false
	if [[ $service_running ]]; then
		isRunning=$true
	fi
}
module_list=("gemini-core" "gemini-firewatch")
if [[ -z $1 ]]; then
	printHelp
	exit
fi
if [[ "$1" -eq "start" ]]; then
	echo "Starting Gemini..."
	echo "---------------------------------------------------------"
	echo ""
	for module in "${module_list[@]}"; do
		systemctl start "$module"
		sleep 1
		verifyRunning "$module"
		if [[ $isRunning ]]; then
			echo "$module status: \033[32;1m[RUNNING]\033[0m"
		else
			echo "$module status: \033[31;1m[FAILED TO START]\033[0m"
		fi
	done
	echo ""
	systemctl start gemini
	sleep 1
	verifyRunning "gemini"
	if [[ $isRunning ]]; then
		echo "Controller status: \033[32;1m[RUNNING]\033[0m"
	else
		echo "Controller status: \033[31;1m[FAILED TO START]\033[0m"
	exit
fi
if [[ "$1" -eq "stop" ]]; then
	echo "Stopping Gemini..."
	echo "---------------------------------------------------------"
	echo ""
	systemctl stop gemini
	sleep 1
	verifyRunning "gemini"
	if ! [[ $isRunning ]]; then
		echo "Controller status: \033[32;1m[TERMINATED]\033[0m"
	else
		echo "Controller status: \033[31;1m[FAILED TO TERMINATE]\033[0m"
	echo ""
	for module in "${module_list[@]}"; do
		systemctl stop "$module"
		sleep 1
		verifyRunning "$module"
		if ! [[ $isRunning ]]; then
			echo "$module status: \033[32;1m[TERMINATED]\033[0m"
		else
			echo "$module status: \033[31;1m[FAILED TO TERMINATE]\033[0m"
		fi
	done
	exit
fi