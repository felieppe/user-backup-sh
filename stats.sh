#!/bin/bash

# Comments:
#
# 1. Missing startup for this script every time the OS starts running (systemctl)
#    This feature should be added manually by now.

clear;

if [ `id -u` -ne 0 ]
        then echo Please run this script as root or using sudo!
        exit 1
fi

DIR_STATS="/Estadisticas"
mkdir -p "${DIR_STATS}"

get_stats() {
	DATE=$(date +%Y-%m-%d_%H-%M-%S)
	OUTPUT="${DIR_STATS}/stats_${DATE}.txt"

	echo "=== Estadísticas del sistema (${DATE}) ===" >> "${OUTPUT}"
    	top -bn1 >> "${OUTPUT}"

	echo "\n=== Estadísticas por proceso (${DATE}) ===" >> "${OUTPUT}"
    	ps aux --sort=-%cpu,-%mem >> "${OUTPUT}"

	printf "[${DATE}] Log writed!\n"
}

while true; do
	get_stats

	printf "Sleeping 60 seconds...\n\n"
	sleep 60
done
