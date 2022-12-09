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
EXITCODE=2
USBMOUNTED=1  # false by default
ATTEMPTS=10
INTERVAL=10
i=1
echo ""
#########################################

printf_current_timestamp
echo " [NOTICE ] Check if USB storage is installed "
printf_current_timestamp
echo " [NOTICE ] Search in location $USBMOUNTDIR for file $MOUNTCHECK "
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


	# CHECK
	#if [ -f $USBMOUNTDIR/$MOUNTCHECK ]; then
	if [ ! -n "$(find "USBMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then
		printf_current_timestamp
		echo " [SUCCESS] USB storage '$USBMOUNTDIR' mounted correctly "
		EXITCODE=0
		break	
	else 	
		printf_current_timestamp
		echo " [WARNING] USB storage not found yet "
		EXITCODE=2
		((i++)) # increment iterator
	fi
	
	
done #while-loop
sleep 1
	

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
echo "------------------------------------[ CSB  END ]--------------------------------"
#"$(date +"%Y-%m-%dT%H:%M:%S.%3N") [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE












