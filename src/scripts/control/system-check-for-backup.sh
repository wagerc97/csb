#!/bin/bash

#-----------------------------------------------------------------------------------------#
# Check connectivity of system to ensure that all requirements for backup are met.
#
# Dieses bash Skript überprüft die Verbindung zum externen Speicher (USB-Stick), zum Internet.
# Dann wird der onedrive verbunden (rlcone stellt eine Verbindung zur Cloud her).
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
source ~/csb/src/config/envconfig.txt

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

ensure_logfolder_structure() {
	# ensure log folders exists otherwise create it
	printf_current_timestamp
	echo " [NOTICE ] Ensure all log folders exist "
	mkdir -pv $PROJECTLOGS
	mkdir -pv $PROJECTLOGSCONTROL/systemcheck
	mkdir -pv $PROJECTLOGSSINGLE/log-reqs
	sleep $SMALLTIMEOUT
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
	$PROJECTSCRIPTS/$script.sh >> $PROJECTLOGSCONTROL/systemcheck/system-check-for-backup-$tscut.log 2>&1

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
		echo " [ ERROR ]  updated EXITCODE $EXITCODE "
	else 
		printf_current_timestamp
		echo " [SUCCESS]  returned exitcode $res "
	fi 
	
	sleep $SMALLTIMEOUT

}


########################################################################

printf_current_timestamp
echo " [NOTICE ] Check connectivity of system to ensure that all requirements for backup are met "

printf_current_timestamp
echo " [NOTICE ] All script executions are logged centrally to $PROJECTLOGSCONTROL/systemcheck/system-check-for-backup-$TIMESTAMPCUT.log "


########################################################################
### CHECK LOGGING REQUIREMENTS

# Ensure log folders exist otherwise create them
ensure_logfolder_structure

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

echo ""
read -r -p  "Press RETURN to continue ... " INPUT
echo "Bye "


exit $EXITCODE

