#!/bin/bash

clear;

if [ `id -u` -ne 0 ]
 	then echo Please run this script as root or using sudo!
 	exit 1
fi

echo 'Running setup requirements for the obligatory...\n'

# UW = User wanted to create
# GW = Group wanted to create

uw="SO_User"
gw="SO"

# Group existence check
if ! getent group $gw > /dev/null 2>&1; then
	if sudo groupadd $gw; then
		echo "Group ${gw} created succesfully."
	else
		echo "Error occurred in process of creating ${gw} group."
	fi
else
	echo "[*] Skipping creating group because is already created."
fi

# User existence check
if ! getent passwd $uw > /dev/null 2>&1; then
	if sudo useradd $uw; then
		echo "User ${uw} created succesfully."
	else
		echo "Error occurred in process of creating ${uw} group."
	fi
else
	echo "[*] Skipping creating user because is already created."
fi

echo "\n"

# Changing security of OS for executing copiaSeguridad.sh with sudo
actualdir="$(dirname "$(realpath "$0")")"
backup_script="${actualdir}/copiaSeguridad.sh"

echo "[**] Changing permissions for executing ${backup_script} with sudo..."

echo "${uw} ALL=(root) NOPASSWD: ${backup_script}" > /etc/sudoers.d/"${uw}"
sudo chmod 0440 /etc/sudoers.d/"${uw}"

# /backup folder existence check
if [ ! -d "/backup" ]; then
	if sudo mkdir "/backup"; then
		echo "Backup folder created successfully."
	else
		echo "Error occurred in process of creating /backup folder."
	fi
fi

echo "\n"

# Ready
echo "[***] Ready!"
