#!/bin/bash

# Date: 05/20/2024
# Author: Felipe Cabrera
# This scripts do a backup of the home directory and files inside of it.

clear;

# Checks if this script is running with sudo/root.
if [ `id -u` -ne 0 ]
        then echo Please run this script as root or using sudo!
        exit 1
fi

printf 'Running backup script...\n'

# Checking script parameters (looking for user).
if [ -z "$1" ]; then
	echo "Usage: $0 {user}"
	exit 1
fi

# Declares variables needed for the execution of the code.
USER=$1
DIR_USER=/home/$USER
DIR_BACKUP=/backup/$USER

# Checks if the user passed in parameters exists or not in the system.
if getent passwd $uw > /dev/null 2>&1; then
	do_backup=1

	# Checks if the backup directory is created.
	if [ ! -d "${DIR_BACKUP}" ]; then
		sudo mkdir "${DIR_BACKUP}"
	else
		read -p "Backup already created. Do you wanna to overwrite? (y/n)" -n 1 -r REPLY

		# Ask the user if it want to overwrite the backup or not.
		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			printf "\nBackup cancelled.\n"
			do_backup=0
		fi
	fi

	# If the user still wants to do the backup process or not.
	if [ "${do_backup}" -eq 1 ]; then
		sudo cp -rp $DIR_USER/* $DIR_BACKUP/
		sudo chown -R root:root --no-dereference $DIR_BACKUP
		sudo chmod -R 400 $DIR_BACKUP

		printf "\n[*] Successfully created backup for ${USER}!\n"
	else
		exit 1
	fi
else
	# Script exists because user passed in parameter not exists.
	echo "Error: ${USER} do not exists in the OS."
	exit 1
fi
