#!/bin/bash

#-----------------------------------------------------------------------------------------#
# [CAUTION] This script is intended for on demand use. Execute whenever NO OTHER backup scripts are running!!!
#  
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



echo""; echo""
echo "-----------------------------------[ CSB  START ]-------------------------------"
echo "bash version: $BASH_VERSION "
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")


############ Define Variables ###########

# import environment variables
source ~/csb/src/config/envconfig.sh
source ~/csb/src/scripts/utility/smallfunctions.sh

# process variables
SMALLTIMEOUT=1
BIGTIMEOUT=5
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
	$PROJECTSCRIPTS/$script.sh >> $PROJECTLOGSCONTROL/ondemand/backup-now-$tscut.log 2>&1

}

#########################################
########################################################################

# Info about logging
printf_current_timestamp
echo " [NOTICE ] This script calls main.sh and will log to $PROJECTLOGSCONTROL/ondemand/backup-now-<timestamp>.log "
printf_current_timestamp
echo " [NOTICE ] main.sh will log to $PROJECTLOGSCONTROL/main/main-<timestamp>.log. Look up this logfile for further details. "
printf_current_timestamp
echo " [NOTICE ] Copy details are logged to $PROJECTLOGSSINGLE/backup/copy_details-<timestamp>.log "

# Ensure log folders exist otherwise create them
ensure_logfolder_structure


########################################################################
### ASK USER TO EXECUTE SCRIPT

echo ""
read -r -p  "Do you want to backup remote storage '$REMOTECONFIG' now? (Y)es or (N)o? " INPUT

# Check user input and proceed accordingly 
case $INPUT in
	[yY][eE][sS]|[yY])
		echo "..."
		echo "You answered '$INPUT'. Proceeding to create backup... "
				
########################################################################
		### CHECK MAIN LOG FOLDER EXISTS 
		 
		printf_current_timestamp
		echo " [NOTICE ] Checking log folder is available under $PROJECTLOGSCONTROL/ondemand "

		# Ensure log folder exists otherwise create it
		mkdir -pv $PROJECTLOGSCONTROL/ondemand
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

		;; # end of YES
		
########################################################################		

	[nN][oO]|[nN])
		echo "..."
		echo "You answered '$INPUT'. Quit $(basename "$0")... "
		EXITCODE=0
		;; # end of NO
	*)
		echo "..."
		echo "Your answer '$INPUT' was invalid. Please type 'yes' or 'no' next time. "
		EXITCODE=1
		;; # end of default
esac


echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"


echo ""
read -r -p  "Press RETURN to continue ... " INPUT
echo "Bye "


exit $EXITCODE

