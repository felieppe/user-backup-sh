#!/bin/bash

clear;

if [ `id -u` -ne 0 ]
        then echo Please run this script as root or using sudo!
        exit 1
fi

printf 'Running backup script...\n'

# Checking script parameters (looking for user)
if [ -z "$1" ]; then
	echo "Usage: $0 {user}"
	exit 1
fi

USER=$1
DIR_USER=/home/$USER
DIR_BACKUP=/backup/$USER

if getent passwd $uw > /dev/null 2>&1; then
	do_backup=1

	if [ ! -d "${DIR_BACKUP}" ]; then
		sudo mkdir "${DIR_BACKUP}"
	else
		read -p "Backup already created. Do you wanna to overwrite? (y/n)" -n 1 -r REPLY

		if [[ ! $REPLY =~ ^[Yy]$ ]]
		then
			printf "\nBackup cancelled.\n"
			do_backup=0
		fi
	fi

	if [ "${do_backup}" -eq 1 ]; then
		sudo cp -rp $DIR_USER/* $DIR_BACKUP/
		sudo chown -R root:root --no-dereference $DIR_BACKUP
		sudo chmod -R 400 $DIR_BACKUP

		printf "\n[*] Successfully created backup for ${USER}!\n"
	else
		exit 1
	fi
else
	echo "Error: ${USER} do not exists in the OS."
	exit 1
fi
