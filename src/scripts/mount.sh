#!/bin/bash

echo "-----------------------------------[ CSB  START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

############ Define Variables ###########

# import environment variables
source ~/csb/src/config/envconfig.sh
source ~/csb/src/scripts/utility/smallfunctions.sh

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
	--config $RCLONECONFIG \
    --allow-other \
    --dir-cache-time 5000h \
    --cache-dir=/tmp/cache \
    --drive-pacer-min-sleep 10ms \
    --drive-pacer-burst 200 \
    --vfs-cache-mode full \
    --vfs-cache-max-size 250G \
    --vfs-cache-max-age 5000h \
    --bwlimit-file 32M \
    --read-only \
    --daemon \
    --daemon-timeout=10m \
    --retries 3 \
    --low-level-retries 3
	
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







