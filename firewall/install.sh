#!/bin/bash
if [ $EUID -ne 0 ]; then
    echo "Must be run as root"
	exit
fi
yum install -y nft
apt install -y nft
if [[ -f /bin/nft ]]; then
	version=$(nft --version)
	numVersion=$(echo "$version" | bc)
	if (( $(echo "$numVersion < 0.5" | bc -l) )); then
		echo "This machine is unable to support nftables version 0.5 or higher. Installing firewall using iptables."
		#IPTABLES FIREWALL INSTALL
	fi
else
	echo "This machine is unable to support nftables. Installing firewall using iptables."
	#IPTABLES FIREWALL INSTALL
fi
yum install -y python
apt install -y python
if [[ -f /bin/python3 ]]; then
	version=$(python3 -version)
	numVersion=$(echo "$version" | bc)
	if (( $(echo "$numVersion < 3.8" | bc -l) )); then
		echo "This machine is unable to support python 3.8 or higher. Installing firewall using iptables."
		#IPTABLES FIREWALL INSTALL
	fi
else
	echo "This machine is unable to support python 3. Installing firewall using iptables."
	#IPTABLES FIREWALL INSTALL
fi
echo "This machine passes all dependency checks. Installing firewaill using nftables."
repo_root=$(git rev-parse --show-toplevel)
bash $repo_root/scripts/linux/firewall/nfTablesFirewall/setup.sh