#!/bin/bash

# Date: 05/20/2024
# Author: Felipe Cabrera
# This scripts fulfills the first requirements for the deliverable.

clear;

# Checks if this script runs with sudo/root.
if [ `id -u` -ne 0 ]
 	then echo Please run this script as root or using sudo!
 	exit 1
fi

echo 'Running setup requirements for the obligatory...\n'

# UW = User wanted to create
# GW = Group wanted to create

# Declares variables for the user and group to create.
uw="SO_User"
gw="SO"

# Checks if in the system exists the needed group.
if ! getent group $gw > /dev/null 2>&1; then
	if sudo groupadd $gw; then
		echo "Group ${gw} created succesfully."
	else
		echo "Error occurred in process of creating ${gw} group."
	fi
else
	echo "[*] Skipping creating group because is already created."
fi

# Checks if in the system exists the needed user.
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

# Changing security of OS for executing copiaSeguridad.sh with sudo, without password.
actualdir="$(dirname "$(realpath "$0")")"
backup_script="${actualdir}/copiaSeguridad.sh"

echo "[**] Changing permissions for executing ${backup_script} with sudo..."

echo "${uw} ALL=(root) NOPASSWD: ${backup_script}" > /etc/sudoers.d/"${uw}"
sudo chmod 0440 /etc/sudoers.d/"${uw}"

# Checks if in the system exists the folder for saving the backups
if [ ! -d "/backup" ]; then
	if sudo mkdir "/backup"; then
		echo "Backup folder created successfully."
	else
		echo "Error occurred in process of creating /backup folder."
	fi
fi

echo "\n"

# Prints final output in the script (ready).
echo "[***] Ready!"
