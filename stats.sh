#!/bin/bash

# Date: 05/20/2024
# Author: Felipe Cabrera
# This scripts parse from the system information about CPU and more, then it save it in a specific directory.

# Comments:
#
# 1. Missing startup for this script every time the OS starts running (systemctl)
#    This feature should be added manually by now.

clear;

# Checks if the script is running in sudo/root.
if [ `id -u` -ne 0 ]
        then echo Please run this script as root or using sudo!
        exit 1
fi

# Declares variables required for the execution of the script.
DIR_STATS="/Estadisticas"
mkdir -p "${DIR_STATS}"

# Get the stats of the system and saves it in the output directory.
get_stats() {
	DATE=$(date +%Y-%m-%d_%H-%M-%S)
	OUTPUT="${DIR_STATS}/stats_${DATE}.txt"

	echo "=== Estadísticas del sistema (${DATE}) ===" >> "${OUTPUT}"
    	top -bn1 >> "${OUTPUT}"

	echo "\n=== Estadísticas por proceso (${DATE}) ===" >> "${OUTPUT}"
    	ps aux --sort=-%cpu,-%mem >> "${OUTPUT}"

	printf "[${DATE}] Log writed!\n"
}

# Executes the get_stats() function and then, sleeps for sixty seconds. After that, repeat in an infinity loop.
while true; do
	get_stats

	printf "Sleeping 60 seconds...\n\n"
	sleep 60
done
