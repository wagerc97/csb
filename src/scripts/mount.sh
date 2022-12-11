#!/bin/bash

echo "-----------------------------------[ CSB  START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

############ Define Variables ###########

# import environment variables
source ~/csb/src/config/envconfig.sh
source ~/csb/src/scripts/utility/smallfunctions.sh


# log rclone copy to seperate file if TRUE
if [ $LOGMOUNT -eq 0 ]; then
	ts=$(date +"%Y-%m-%dT%H:%M:%S")
	MOUNTLOGFILE=$PROJECTLOGSSINGLE/backup/copy_details-$ts.log
	# create the logfile
	touch $MOUNTLOGFILE
else
	MOUNTLOGFILE=""
fi

# process variables
SMALLTIMEOUT=2
BIGTIMEOUT=20
EXITCODE=1
MOUNTED=1  # default to FALSE
INTERVAL=10
ATTEMPTS=10
i=1
echo ""
#########################################

printf_current_timestamp
echo " [NOTICE ] Checking rlcone connectivity to remote storage '$REMOTECONFIG' "


### Check if prepared folder for remote storage exists 
if [ -d $REMOTEMOUNTDIR ]; then

	printf_current_timestamp
	echo " [SUCCESS] Local mount target folder $REMOTEMOUNTDIR exists "
			
else

	printf_current_timestamp
	echo " [WARNING] Local mount target folder $REMOTEMOUNTDIR does not exist "
	printf_current_timestamp
	echo " [NOTICE] Creating folder... "
	
	# Create the folder anew and grant it full modification rights to everyone (each command needs time!)
	rmdir $REMOTEMOUNTDIR 
	sleep 0.5
	sudo mkdir -pv $REMOTEMOUNTDIR 
	sleep 0.5
	sudo chmod 777 $REMOTEMOUNTDIR
	sleep 0.5
	
	if [ -d $REMOTEMOUNTDIR ]; then
		printf_current_timestamp
		echo " [SUCCESS] Local mount target folder $REMOTEMOUNTDIR was created "
		#printf_current_timestamp
		#echo " [NOTICE ] waiting for $SMALLTIMEOUT seconds ..."
		#sleep $SMALLTIMEOUT
	else 
		printf_current_timestamp
		echo " [F ERROR] Log folder could not be created "
		echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
		echo "-----------------------------------[ CSB  ]-------------------------------"
		#echo $(date +"%Y-%m-%dT%H:%M:%S.%3N") " [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
		#sleep $BIGTIMEOUT
		EXITCODE=1
		exit $EXITCODE
	fi
fi		

### Check if the volume is mounted
if [ ! -n "$(find "$REMOTEMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
	printf_current_timestamp
	echo " [SUCCESS] Remote storage volume '$REMOTECONFIG' is already mounted at $REMOTEMOUNTDIR "
else
	printf_current_timestamp
	echo " [WARNING] Remote storage volume '$REMOTECONFIG' not mounted correctly "
	printf_current_timestamp
	echo " [NOTICE ] Un-Mount '$REMOTECONFIG' first ... "
	
	# UNMOUNT volume first
	fusermount -u $REMOTEMOUNTDIR || sudo umount -f $REMOTEMOUNTDIR || sudo umount -l $REMOTEMOUNTDIR 
	sleep $SMALLTIMEOUT
	
	# MOUNT volume (again)
	printf_current_timestamp
	echo " [NOTICE ] Mount '$REMOTECONFIG' as volume on $REMOTEMOUNTDIR ... "
	
	# $REMOTECONFIG is the test config with my personal onedrive
	# Explanation of mount command
	#  mount volume_id to Local mount target directory and do it verbose x3
	# FLAGS USED:
	# -vvv                    logging level (more v, more log lines)
	# --config                location of config file
	#
	# NOTES
	# chmod 777 on the mount point for pi and good
	# thanks -vvv
	#rclone -vvv mount $REMOTECONFIG: $REMOTEMOUNTDIR  # <- this one works
		
	#--------------------------------------------------------------#
  # Credit: Thanks to animosity22
  # https://github.com/animosity22/homescripts/blob/master/systemd/rclone-drive.service

	rclone -vvv mount $REMOTECONFIG: $REMOTEMOUNTDIR \
	#--config $RCLONECONFIG \
	#
	# This is for allowing users other than the user running rclone access to the mount
  --allow-other \
  # Google Drive is a polling remote so this value can be set very high and any changes are detected via polling.
  # One Drive idk
  --dir-cache-time 5000h \
  # Log file location
  --log-file $MOUNTLOGFILE \
  # Set the log level
  #--log-level NOTICE \
  # I reduce the poll interval down to 1 min as this makes changes appear fast the API quotas per day are huge (was 10s)
  --poll-interval 1m \
  # This is setting the file permission on the mount to user and group have the same access and other can read
  #--umask 002 \
  # Please set this to your own value below
  #--user-agent someappname101 \
  #
  # This sets up the remote control daemon so you can issue rc commands locally
  --rc \
  # This is the default port it runs on
  --rc-addr 127.0.0.1:5572 \
  # no-auth is used as no one else uses my server and it is not a shared seedbox
  --rc-no-auth \
  # The local disk used for caching
  --cache-dir=/tmp/cache \
  #
  # My quota per user / per 100 seconds is 20,000 requests. This can be found in your quota section.
  # This changes the sleep calls to something much lower to take advantage of the API boost.
  # change the min sleep from 100ms
  --drive-pacer-min-sleep 10ms \
  # Changing to have the ability to burst higher
  --drive-pacer-burst 200 \
  # This is used for caching files to local disk for streaming
  # Not: I originally used writes  # --vfs-cache-mode writes \
  --vfs-cache-mode full \
  # This limits the cache size to the value below
  --vfs-cache-max-size 250G \
  # This limits the age in the cache if the size is reached and it removes the oldest files first
  --vfs-cache-max-age 5000h \
  # The polling interval for increased based on there is enough buffer space
  --vfs-cache-poll-interval 5m \
  # This sets a per file bandwidth control and I limit this to a little bigger than my largest bitrate I'd want to play
  --bwlimit-file 32M \
	# if a filename not found, find a case insensitive match -> less troubles
  --vfs-case-insensitive \
  # cannot change anything on remote source
  --read-only \
  #	process runs in background (allows closing terminal without problems)
 	--daemon \
  # time for process to report back
  --daemon-timeout=10m
	
	#--------------------------------------------------------------#
	
	echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "
fi



# Look for check-file in mounted storage
# Loop implemented to wait until remote storage connection is live
printf_current_timestamp
echo " [NOTICE ] Check if mount was successful for $ATTEMPTS times every $INTERVAL seconds "
printf_current_timestamp
echo " [NOTICE ] Check if directory $REMOTEMOUNTDIR is empty "

while [ $i -le $ATTEMPTS ]; do
	printf_current_timestamp
	echo " [NOTICE ] Attempt: $i/$ATTEMPTS "

	if [ $i -gt 1 ]; then
		printf_current_timestamp
		echo " [NOTICE ] Retry in $INTERVAL seconds... "
		sleep $INTERVAL
	fi
	
	# CHECK: Look for checkfile MOUNTCHECK in directory REMOTEMOUNTDIR
	if [ ! -n "$(find "$REMOTEMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
		printf_current_timestamp
		echo " [SUCCESS] Volume '$REMOTECONFIG' mounted correctly "
		EXITCODE=0
		break
	else
		printf_current_timestamp
		echo " [WARNING] Volume '$REMOTECONFIG' not found yet "
		EXITCODE=2
		((i++)) # increment iterator
	fi
	

done # end while-loop


# Evaluate result of mount check
if [ $EXITCODE -ne 0 ]; then
	printf_current_timestamp
	echo " [F ERROR] Volume '$REMOTECONFIG' is not mounted (exit code $EXITCODE)"
fi

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"
#echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE







