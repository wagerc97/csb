#!/bin/bash

echo "-----------------------------------[ CSB  START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo ""

############ Define Variables ###########

# import environment variables (not required for check-web.sh)
source ~/csb/src/config/envconfig.txt

ONLINE=1 # false by default
INTERVAL=10
ATTEMPTS=10
SMALLTIMEOUT=3
BIGTIMEOUT=10
EXITCODE=2
i=1
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

#########################################


printf_current_timestamp
echo " [NOTICE ] Check connection to internet "
printf_current_timestamp
echo " [NOTICE ] Try to ping for $ATTEMPTS times every $INTERVAL seconds until successful "

### Ping fixed Goolge IP at $INTERVAL Minute Intervals to check connectivity
# -ne ... not equal 
# -lt ... less than
# -le ... less than or equal
# -gt ... greater than 

# If not online AND there are attempts left
while [ $ONLINE -ne 0 ] && [ $i -le $ATTEMPTS ]; do

	printf_current_timestamp
	echo " [NOTICE ] Attempt: $i/$ATTEMPTS "

	# If it is not the first attempt
	if [ $i -gt 1 ]; then
		printf_current_timestamp
		echo " [NOTICE ] Retry in $INTERVAL seconds... "
		sleep $INTERVAL
	fi

	#### Info: Ping flags ####
	# -i1 wait 1 second between ping
	# -c2 ping twice
	# -w5 stop printing ping results after 5 seconds
	# -q "quiet" prints only one regular ping 8.8.8.8 command and the statistics

	# ping and redirect output to be discarded
	#ping -i1 -c5 -w10 8.8.8.8 >/dev/null 2>&1
	
	# CHECK: Alternative ping without discarding output
	ping -i1 -c5 8.8.8.8
	ONLINE=$?
	
	# EVALUATION
	if [ $ONLINE -ne 0 ]; then 
		printf_current_timestamp
		echo " [WARNING] System has not found a connection to the Internet yet "
		EXITCODE=2
		((i++)) # increment iterator
	else 
		printf_current_timestamp
		echo " [SUCCESS] System is connected to the Internet "
		EXITCODE=0
		break
	fi
	

done #while-loop


# FINAL OUTPUT
if [ $EXITCODE -gt 0 ]; then
	printf_current_timestamp
	echo " [F ERROR] System could not connect to the Internet "
	printf_current_timestamp
	echo " [NOTICE ] Tried to ping for $ATTEMPTS times every $INTERVAL seconds "
fi

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"
#echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE




