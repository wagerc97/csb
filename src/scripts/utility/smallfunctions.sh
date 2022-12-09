#!/bin/bash

#-----------------------------------------------------------------------------------------#
# This bash script contains smaller reoccurring utility functions.
# Part of the "cloud-storage-backup" project
# Author: Clemens Wager
# Last revisited: 2022-12-09
#-----------------------------------------------------------------------------------------#

# Import environment variables
source ~/csb/src/config/envconfig.sh


printf_current_timestamp () {
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}


ensure_logfolder_structure () {
	# ensure log folders exist otherwise create them
	# Gets called in every controlling script
	printf_current_timestamp
	echo " [NOTICE ] Ensure all log folders exist "
	mkdir -pv ~/csb/logs
	mkdir -pv ~/csb/logs/control
	mkdir -pv ~/csb/logs/control/main
	mkdir -pv ~/csb/logs/control/systemcheck
	mkdir -pv ~/csb/logs/control/daily
	mkdir -pv ~/csb/logs/control/ondemand
	mkdir -pv ~/csb/logs/control/reboot
	mkdir -pv ~/csb/logs/single
	mkdir -pv ~/csb/logs/single/check-web
	mkdir -pv ~/csb/logs/single/check-usb
	mkdir -pv ~/csb/logs/single/unmount
	mkdir -pv ~/csb/logs/single/mount
	mkdir -pv ~/csb/logs/single/backup
	sleep 1

	printf_current_timestamp
  echo " [NOTICE ] Modify permissions for CSB log folders"
 	chmod -R +x ~/csb/logs/

}


process_script_exitcode () {
	# This function processes the exitcode of the last script execution
	#
	# Use it directly after the script execution as follows:
	#	process_script_exitcode $?
	#
	# Parameters:
	#	the exitcode returned from script execution

	res=$1  # store the first parameters in a variable name

	if [ $res -ne 0 ]; then
		printf_current_timestamp
		echo " [ ERROR ]  returned exitcode $res "
		((EXITCODE++))
		printf_current_timestamp
		echo " [ ERROR ]  updated EXITCODE $EXITCODE "
	else
		printf_current_timestamp
		echo " [SUCCESS]  returned exitcode $res "
	fi

	sleep 1
}

