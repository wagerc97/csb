#!/bin/bash

#-----------------------------------------------------------------------------------------#
# This bash script will copy all files on the remote storage (onedrive) that have changed to a local directory
# Dieses bash Skript kopiert alle Datein, die verändert wurden, auf ein lokales Speichermedium (USB-stick, externe Festplatte, ... was auch immer konfiguriert wurde -> DESTDIR)
# Part of the "cloud-storage-backup" project
# Author: Clemens Wager
# Last revisited: 2022-12-04
#-----------------------------------------------------------------------------------------#


echo "-----------------------------------[ CSB  START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo ""

#########################################
############ Define Variables ###########

# import environment variables
source ~/csb/src/config/envconfig.txt

# log rclone copy to seperate file if TRUE
if [ $LOGBACKUP -eq 0 ]; then
	ts=$(date +"%Y-%m-%dT%H:%M:%S")
	COPYLOGFILE=$PROJECTLOGSSINGLE/backup/copy_details-$ts.log
	touch $COPYLOGFILE
else 
	COPYLOGFILE=""
fi

# process variables
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S.%3N") 
SMALLTIMEOUT=1
BIGTIMEOUT=5
EXITCODE=0
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
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
	#if [ $res -ne 0 ]; then 
	#	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
	#	echo " [ERROR ]  returned exitcode '$res' "
	#else 
	#	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
	#	echo " [SUCCESS]  returned exitcode '$res' "
	#fi 
	#sleep $SMALLTIMEOUT
	
	echo "Result: $res "

}

#########################################

printf_current_timestamp
echo " [NOTICE ] Backup all updated files and folders from (remote) '$SOURCEDIR' to (local) '$DESTDIR' " 

printf_current_timestamp
echo " [NOTICE ]  Calling rclone copy ... " 

# We will use rclone's innate copy command
# rclone copy source:sourcepath dest:destinationpath
# EXPLANATION OF FLAGS
# -v / -vv / -vvv				-v basic output / -vv debug output / -vvv all output
# --progress/-P 				to view real-time transfer statistics.
# --dry-run or --interactive/-i to test without copying anything.
# --create-empty-src-dirs 		to copy empty folders as well 
# --filter-from to set rule 	to exclude (-) or include (+) files/folders 
# --ignore-case 				to match without case sensitivity 
# --transfers=4 				number of files tranferred in parallel (default 4). Increase on stable connection, decrease on slow connection and weak backend. 16 had best results during test on RPI
# --log-file=$COPYLOGFILE		logs to file 
# --fast-list 					for large sync/copy operations, uses more RAM (~4GB on this RPI)
# --checksum					rclone will check the file hash and size to determine if files are equal (instead of just file size)

# CHECK THESE FLAGS OUT
# look into these... 
# --s3-upload-cutoff=200M 		large files are cut into pieces of 200M
# --s3-chunk-size=5M 			general "sweet spot" for most operations (default 4.5 MiB)
# --chunker-chunk-size			chunk size (default 2GiB)
# --max-age=1d					saves time traversing when backups are carried out daily, but BAD if there are days in between (outages)
# 


rclone copy -v $SOURCEDIR $DESTDIR \
--create-empty-src-dirs \
--filter-from=$FILTERLIST --ignore-case \
--fast-list \
--transfers=16 \
--checksum \
--log-file=$COPYLOGFILE

#tsend=$(date +"%Y-%m-%dT%H:%M:%S")  # store the end time for debugging

printf_current_timestamp
echo " [NOTICE ] Rclone copy finished! For further information read the log: $COPYLOGFILE "



echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"

# for debugging
#echo "start time: $ts"
#echo "  end time: $tsend"
# for debugging: deletes the just copied files and folder
#rm -rf $DESTDIR 

exit $EXITCODE

