#!/bin/bash

#-----------------------------------------------------------------------------------------#
# If configured accordingly as Cronjob:
# Upon booting the system this script will be called and it will wait for a few seconds to let the system clock update (ensures correct logging).
#
# Purpose
# This script will check the connectivity to your local (i.e. external) storage device and to the internet.
# Then the remote storage (i.e. onedrive) will be un-mounted and mounted.
# Then all changes on the remote storage are copied to a local directory.
#
# Dieses bash Skript überprüft die Verbindung zum externen Speicher (USB-Stick), zum Internet.
# Dann wird der onedrive verbunden (rlcone stellt eine Verbindung zur Cloud her).
# Zuletzt kopiert dieses bash Skript alle Datein, die verändert wurden, auf ein lokales Speichermedium (USB-stick, externe Festplatte, ... was auch immer konfiguriert wurde -> DESTDIR)
#
# Warning
# - Execute this script only when NO OTHER CSB scripts are running!!!
# - Files with the same name will be overwritten.
#
# Recommended usage
# Use this script with a scheduling service f.e. Cronjobs to create a backup of the configured remote storage automatically.
# Check the logs for information on the execution.
#
# Part of the "cloud-storage-backup" project
# Author: Clemens Wager
# Last revisited: 2022-12-06
#-----------------------------------------------------------------------------------------#



echo""; echo""; echo""; echo""
echo "-----------------------------------[ CSB  START ]-------------------------------"
echo "bash version: $BASH_VERSION "
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")


############ Define Variables ###########

# import environment variables
source ~/csb/src/config/envconfig.sh
source ~/csb/src/scripts/utility/smallfunctions.sh

# process variables
SMALLTIMEOUT=1
BIGTIMEOUT=30
EXITCODE=0
echo ""
#########################################
############ Define Functions ###########

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
	$PROJECTSCRIPTS/$script.sh >> $PROJECTLOGSCONTROL/reboot/reboot-call-main-$tscut.log 2>&1

}

#########################################
########################################################################

# Info about logging
printf_current_timestamp
echo " [NOTICE ] This script calls main.sh and will log to $PROJECTLOGSCONTROL/reboot/reboot-call-main-<timestamp>.log "
printf_current_timestamp
echo " [NOTICE ] main.sh will log to $PROJECTLOGSCONTROL/main/main-<timestamp>.log. Look up this logfile for further details. "
printf_current_timestamp
echo " [NOTICE ] Copy details are logged to $PROJECTLOGSSINGLE/backup/copy_details-<timestamp>.log "


# Ensure log folders exist otherwise create them
ensure_logfolder_structure


# Info about wait upon reboot
printf_current_timestamp
echo " [NOTICE ] Waiting for $BIGTIMEOUT seconds until system clock is uptodate ... "
sleep $BIGTIMEOUT
printf_current_timestamp
echo " [NOTICE ] Waiting finished - Let's go! "

########################################################################
### CHECK MAIN LOG FOLDER EXISTS 
 
printf_current_timestamp
echo " [NOTICE ] Checking log folder is available under $PROJECTLOGSCONTROL/reboot "

# Ensure log folder exists otherwise create it
mkdir -pv $PROJECTLOGSCONTROL/reboot
sleep $SMALLTIMEOUT


########################################################################
### CALL main.sh which runs all smaller scripts
 
printf_current_timestamp
echo " [NOTICE ] Start execution of main.sh script "

call_bash_script main
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
exit $EXITCODE

