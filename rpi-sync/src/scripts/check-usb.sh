#!/bin/bash

echo "-----------------------------------[ RPI-SYNC START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

############ Define Variables ###########

# import environment variables
source ~/rpi-sync/src/config/envconfig.txt

# process variables
SMALLTIMEOUT=1
BIGTIMEOUT=3
EXITCODE=1
USBMOUNTED=1  # false by default
ATTEMPTS=10
INTERVAL=5
i=1
echo ""
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

#########################################


printf_current_timestamp
echo " [NOTICE ] Check if USB storage is installed "
printf_current_timestamp
echo " [NOTICE ] Check if $USBMOUNTDIR is compatible and not empty "
printf_current_timestamp
echo " [NOTICE ] Checking for $ATTEMPTS times every $INTERVAL seconds until successful "


### Ping fixed Goolge IP at $INTERVAL Minute Intervals to check connectivity
# -ne ... not equal 
# -lt ... less than
# -le ... less than or equal
# -gt ... greater than 

# If not online AND there are attempts left
while [ $i -le $ATTEMPTS ]; do

	printf_current_timestamp
	echo " [NOTICE ] Attempt: $i/$ATTEMPTS "

	# If it is not the first attempt
	if [ $i -gt 1 ]; then
		printf_current_timestamp
		echo " [NOTICE ] Retry in $INTERVAL seconds... "
		sleep $INTERVAL
	fi
	
	# Copy a temporary checkfile on usb storage
	printf_current_timestamp
	echo " [NOTICE ] Transfer file on local external storage device "
	cp -v $USBCHECKFILE $USBMOUNTDIR
	sleep $BIGTIMEOUT

	# CHECK
	#if [ -f $USBMOUNTDIR/$MOUNTCHECK ]; then
	if [ ! -n "$(find "$USBMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
		EXITCODE=0
	else 	
		printf_current_timestamp
		echo " [WARNING] USB storage not found yet "
		EXITCODE=2
		((i++)) # increment iterator
	fi
	
	# Remove the file again from USB storage
	printf_current_timestamp
	printf " [NOTICE ] Delete checkfile again: "
	find $USBMOUNTDIR -mindepth 0 -mtime -1 -type f -name $CHECKFILENAME -print -delete
	sleep $BIGTIMEOUT
	
	# Break loop if successful
	if [ $EXITCODE -eq 0 ]; then 
		printf_current_timestamp
		echo " [SUCCESS] USB storage '$USBMOUNTDIR' mounted correctly "
		break
	fi
	
done #while-loop
	

# FINAL OUTPUT
if [ $EXITCODE -gt 0 ]; then
	printf_current_timestamp
	echo " [F ERROR] USB storage '$USBMOUNTDIR' is not mounted "
	printf_current_timestamp
	echo " [WARNING] Please insert the USB storage into Raspberry Pi "
	printf_current_timestamp
	echo " [NOTICE ] Tried to ping for $ATTEMPTS times every $INTERVAL seconds "
fi
	
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ RPI-SYNC END ]--------------------------------"

exit $EXITCODE












