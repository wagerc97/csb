#!/bin/bash

echo "-----------------------------------[ RPI-SYNC START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

############ Define Variables ###########

# import environment variables
source ~/rpi-sync/src/config/envconfig.txt

# process variables
SMALLTIMEOUT=0.5
BIGTIMEOUT=10
EXITCODE=0
NUMFOLDER=7
echo ""
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

#########################################

### Check if each log folders for all scripts exist
# get the name of each script by concatinating with iterator 
printf_current_timestamp
echo " [NOTICE ] Checking if log folder for all scripts exist "

# Each of the names will be folder. Add new required folders at the end of the list.
for eachfolder in check-web check-usb unmount mount backup ; do

	if [ -d $PROJECTLOGSSINGLE/$eachfolder ]; then
		printf_current_timestamp
		echo " [SUCCESS] Log folder for '$eachfolder' exist "
		
	else
		printf_current_timestamp
		echo " [WARNING] Log folder for '$eachfolder' does not exist. Creating folder... "
		mkdir -pv $PROJECTLOGSSINGLE/$eachfolder

		if [ -d $PROJECTLOGSSINGLE/$eachfolder ]; then
			printf_current_timestamp
			echo " [SUCCESS] Log folder for '$eachfolder' was created "
		else 
			printf_current_timestamp
			echo " [F ERROR] Log folder for '$eachfolder' could not be created "
			((EXITCODE++))
		fi
	fi		
	
	sleep $SMALLTIMEOUT
	
done #end for loop

for eachfolder in systemcheck main daily ondemand reboot ; do

	if [ -d $PROJECTLOGSCONTROL/$eachfolder ]; then
		printf_current_timestamp
		echo " [SUCCESS] Log folder for '$eachfolder' exist "
		
	else
		printf_current_timestamp
		echo " [WARNING] Log folder for '$eachfolder' does not exist. Creating folder... "
		mkdir -pv $PROJECTLOGSCONTROL/$eachfolder

		if [ -d $PROJECTLOGSCONTROL/$eachfolder ]; then
			printf_current_timestamp
			echo " [SUCCESS] Log folder for '$eachfolder' was created "
		else 
			printf_current_timestamp
			echo " [F ERROR] Log folder for '$eachfolder' could not be created "
			((EXITCODE++))
		fi
	fi		
	
	sleep $SMALLTIMEOUT
	
done #end for loop



echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "

printf_current_timestamp
echo " [NOTICE ] $EXITCODE of $NUMFOLDER necessary logfolders caused problems "
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ RPI-SYNC END ]--------------------------------"
exit $EXITCODE










