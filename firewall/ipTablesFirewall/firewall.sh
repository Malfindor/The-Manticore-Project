#!/bin/bash
# NOTE: Manticore port shows as "elad", Arbiter port shows as "dslrap"
if [ $EUID -ne 0 ]; then
    echo "Must be run as root"
	exit
fi
addToBlacklist() #Usage: addToBlacklist {ip}
{
	local blacklistIP="$1"
	
	iptables -A INPUT -s $blacklistIP -j DROP
	iptables -A OUTPUT -d $blacklistIP -j DROP
}
removeFromBlacklist() #Usage: removeFromBlacklist {ip} NOT DONE
{
	local blacklistIP="$1"
}
addToWhitelist() #Usage: addToWhitelist {ip}
{
	local whitelistIP="$1"
	
	iptables -A INPUT -s $whitelistIP -j ACCEPT
	iptables -A OUTPUT -d $whitelistIP -j ACCEPT
}
removeFromWhitelist() #Usage: removeFromWhitelist {ip} NOT DONE
{
	local whitelistIP="$1"
}
getChainList() #Usage: getChainList {chain} {variable name to save array to}
{
	local validChains=("INPUT" "OUTPUT" "FORWARD" "input" "output" "forward")
	local chainName="$1"
	local isValid="false"
	for chain in "${validChains[@]}"; do
		if [[ "$chainName" == "$chain" ]]; then
			isValid="true"
		fi
	done
	if [[ "isValid" == "false" ]]; then
		echo "Invalid chain entry"
		exit
	fi
	case "$chainName" in
		"INPUT")
			chainName="INPUT"
		;;
		"input")
			chainName="INPUT"
		;;
		"OUTPUT")
			chainName="OUTPUT"
		;;
		"output")
			chainName="OUTPUT"
		;;
		"FORWARD")
			chainName="FORWARD"
		;;
		"forward")
			chainName="FORWARD"
		;;
		*)
			echo "An error occured in chain name translation."
			exit
		;;
	esac
	local targetChainStartIndex=$((-1))
	local fullChainList=$(iptables -L --line-numbers)
	mapfile -t fullChainListSplit <<< "$fullChainList"
	local num=$((0))
	local currentLine=""
	while [ "$num" -lt "${#fullChainListSplit[@]}" ]; do
		currentLine="${fullChainListSplit[$num]}"
		if ! [[ ${#currentLine} -eq 0 ]]; then
			IFS=" " read -ra currentLineSplit <<< "$currentLine"
			if [[ "${currentLineSplit[0]}" == "Chain" ]] && [[ "${currentLineSplit[1]}" == "$chainName" ]]; then
				targetChainStartIndex=$num
			fi
		fi
		((num=$num+1))
	done
	num=$(($targetChainStartIndex+1))
	local targetChainEndIndex=$((0))
	while [ "$num" -lt "${#fullChainListSplit[@]}" ]; do
		currentLine="${fullChainListSplit[$num]}"
		if ! [[ ${#currentLine} -eq 0 ]]; then
			IFS=" " read -ra currentLineSplit <<< "$currentLine"
			if [[ "${currentLineSplit[0]}" -eq "Chain" ]] && [[ $targetChainEndIndex -eq 0 ]]; then
				targetChainEndIndex=$(($num-1))
			fi
		fi
		((num=$num+1))
	done
	if ! [[ $targetChainEndIndex -gt 0 ]]; then
		targetChainEndIndex=$((${#fullChainListSplit[@]}))
	fi
	if [[ $targetChainEndIndex -lt $targetChainStartIndex ]]; then
		echo "An error occured in finding the selected chain's boundaries"
		exit
	fi
	num=$targetChainStartIndex
	local -n returnArray="$2"
	returnArray=()
	while [ $num -lt $targetChainEndIndex ]; do
		currentLine="${fullChainListSplit[$num]}"
		if ! [[ ${#currentLine} -eq 0 ]]; then
			returnArray+=("$currentLine")
		fi
		((num=$num+1))
	done
}
getPortTranslationTCP() #Usage: getPortTranslationTCP {port} {variable to save to}         ||| This function will convert TCP ports from default protocol name -> port number, or port number -> default protocol name
{
	local input="$1"
	local -n returnString="$2"
	returnString=""
	
	case "$input" in
	"http")
		returnString="80"
	;;
	"https")
		returnString="443"
	;;
	"domain")
		returnString="53"
	;;
	"elad")
		returnString="1893"
	;;
	"dlsrap")
		returnString="1973"
	;;
	"smtp")
		returnString="25"
	;;
	"pop3")
		returnString="110"
	;;
	"irdmi")
		returnString="8000"
	;;
	"webcache")
		returnString="8080"
	;;	
	"8089")
		returnString="8089"
	;;
	*)	
	;;
	esac
}
verifyIntegrity() #Usage: verifyIntegrity {variable to save true/false to}
{
	
}
if [[ -z "$1" ]]; then
	mainCont="true"
	while [ "$mainCont" -eq "true" ]; do
		verifyIntegrity verified
		clear
		if [[ "$verified" -eq "false" ]]; then
			echo "Firewall Status: \033[31;1m[INACTIVE]\033[0m"
			echo "\033[33;1m[Terminating to avoid crashes due to missing structure. Run firewall with the '-i' flag to verify integrity.]\033[0m"
			exit
		else
			echo "Firewall Status: \033[32;1m[ACTIVE]\033[0m"
		fi
		getChainList input inputInfoRaw
		getChainList forward forwardInfoRaw
		getChainList output outputInfoRaw
		

	done
fi