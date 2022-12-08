#!/bin/bash

#-----------------------------------------------------------------------------------------#
# This bash script will check the connectivity to the externale storage device and to the internet.
# Then the remote storage (onedrive) will be connected (rclone mount) and all new files on the remote storage that have changed are copied to a local directory.
#
# Dieses bash Skript überprüft die Verbindung zum externen Speicher (USB-Stick), zum Internet.
# Dann wird der onedrive verbunden (rlcone stellt eine Verbindung zur Cloud her).
# Zuletzt kopiert dieses bash Skript alle Datein, die verändert wurden, auf ein lokales Speichermedium (USB-stick, externe Festplatte, ... was auch immer konfiguriert wurde -> DESTDIR)
#
# Part of the "cloud-storage-backup" project
# Author: Clemens Wager
# Last revisited: 2022-12-06
#-----------------------------------------------------------------------------------------#


echo "-----------------------------------[ CSB  START ]-------------------------------"
echo "bash version: $BASH_VERSION "
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S.%3N") # variable defined earlier so that main starting timestamp and according central logfile match timestamp in name
TIMESTAMPCUT=$(echo "$TIMESTAMP" |cut -d'.' -f1)
echo $(basename "$0") "|" $TIMESTAMP


#########################################
############ Define Variables ###########

# import environment variables
source ~/cloud-storage-backup/src/config/envconfig.txt

# process variables
SMALLTIMEOUT=1
BIGTIMEOUT=5
EXITCODE=0
echo ""
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

call_bash_script () {
	# This function calls a BASH script and logs to output to a new file called <script_name>-<timestamp>.log
	#
	# Use it directly after the script execution as follows (without .sh):
	#	call_bash_script script_name
	#
	# Parameters: 
	#	bash script name

	script=$1  # store the first parameters in a variable name 
	
	# store the current timestamp in a variable
	ts=$(date +"%Y-%m-%dT%H:%M:%S.%3N")  
	# print to announce execution of script
	echo "$ts [NOTICE ]  calling $script.sh ... " 
	# cut the ts string variable to strip off the milliseconds
	tscut=$(echo "$ts" |cut -d'.' -f1)
	# execute the script and log its output
	$PROJECTSCRIPTS/$script.sh >> $PROJECTLOGSSINGLE/$script/$script-$tscut.log 2>&1

}

call_bash_script_and_log_centrally () {
	# This function calls a BASH script and logs to output to a new central file called central-<timestamp>.log
	#
	# Use it directly after the script execution as follows (without .sh):
	#	call_bash_script_and_log_centrally script_name
	#
	# Parameters: 
	#	bash script name

	script=$1  # store the first parameters in a variable name 
	
	# store the current timestamp in a variable
	ts=$(date +"%Y-%m-%dT%H:%M:%S.%3N")  
	# print to announce execution of script
	echo "$ts [NOTICE ]  calling $script.sh ... " 
	# cut the ts string variable to strip off the milliseconds
	tscut=$(echo "$TIMESTAMP" |cut -d'.' -f1)
	# execute the script and log its output
	$PROJECTSCRIPTS/$script.sh >> $PROJECTLOGSCONTROL/main/main-$tscut.log 2>&1

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
		((EXITCODE++))  # Update exitcode
		printf_current_timestamp
		echo " [ ERROR ]  updated main-EXITCODE $EXITCODE "
	else 
		printf_current_timestamp
		echo " [SUCCESS]  returned exitcode $res "
	fi 
	
	sleep $SMALLTIMEOUT

}


########################################################################
printf_current_timestamp
echo " [NOTICE ] Setup up and check all necessary connections. Then create a cloud backup for '$REMOTECONFIG' in directory $DESTDIR "

printf_current_timestamp
echo " [NOTICE ] All script executions are logged centrally to $PROJECTLOGSCONTROL/main/main-$TIMESTAMPCUT.log "


########################################################################
### CHECK LOGGING REQUIREMENTS

printf_current_timestamp
echo " [NOTICE ] Check all log folders are available under $PROJECTLOGSCONTROL "

# ensure log folder exists otherwise create it
mkdir -pv $PROJECTLOGSSINGLE/log-reqs
mkdir -pv $PROJECTLOGSCONTROL/main
sleep $SMALLTIMEOUT

call_bash_script_and_log_centrally log-reqs
process_script_exitcode $?


########################################################################
### CHECK INTERNET CONNECTION 
 
printf_current_timestamp
echo " [NOTICE ] Check internet connection "

call_bash_script_and_log_centrally check-web
process_script_exitcode $?


########################################################################
### CHECK USB CONNECTION 
 
printf_current_timestamp
echo " [NOTICE ] Check USB connection "

call_bash_script_and_log_centrally check-usb
process_script_exitcode $?


########################################################################
### UN-MOUNT REMOTE STORAGE (ONEDRIVE) 
 
printf_current_timestamp
echo " [NOTICE ] Un-mount remote storage "

call_bash_script_and_log_centrally unmount
process_script_exitcode $?


########################################################################
### MOUNT REMOTE STORAGE (ONEDRIVE) 
 
printf_current_timestamp
echo " [NOTICE ] Mount remote storage "

call_bash_script_and_log_centrally mount
process_script_exitcode $?


########################################################################
### CREATE THE BACKUP
# The script backup.sh will copy all files on the remote storage (onedrive) that changed to a local directory
 
printf_current_timestamp
echo " [NOTICE ] Backup data on remote storage "

call_bash_script_and_log_centrally backup
process_script_exitcode $?

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "

########################################################################
### CLOSING MESSAGE

if [ $EXITCODE -ne 0 ]; then
	printf_current_timestamp
	echo " [F ERROR] Execution of main.sh encountered $EXITCODE errors. Please read the logs and troubleshoot accordingly! "
else
	printf_current_timestamp
	echo " [SUCCESS] Process successful! "
fi


echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"
#echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE






