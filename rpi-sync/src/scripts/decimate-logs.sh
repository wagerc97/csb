#!/bin/bash

#-----------------------------------------------------------------------------------------#
# This bash script will delete all logfiles older than the specified date.
# Usage: This file will be called routinely by a cronjob. Otherwise the RPI internal storage will run full with logfiles. 
# Part of the "rpi-sync" project
# Author: Clemens Wager
# Last revisited: 2022-12-06
#-----------------------------------------------------------------------------------------#


echo "-----------------------------------[ RPI-SYNC START ]-------------------------------"
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo ""

############ Define Variables ###########

# import environment variables
source ~/rpi-sync/src/config/envconfig.txt

# process variables
SMALLTIMEOUT=2
BIGTIMEOUT=20
EXITCODE=0
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

#########################################


printf_current_timestamp
echo " [NOTICE ] Start of routine: $(basename "$0"). For more information on this routine execution view the crontab! "
printf_current_timestamp
echo " [NOTICE ] All logfiles older than $MAXAGE days will be deleted from the $PROJECTLOGS and subfolders. "


printf_current_timestamp
echo " [NOTICE ] Starting to decimate the following logfiles ... "
echo "" 
# FLAG EXPLANATION
# find			linux find command
# -mindepth 1	necessary, otherwise target current directory -> '.'
# -maxdepth 2	folder depth
# -mtime +30	filter for files older (+) than 14 days
# -type f		only target files, not directories
# -name \*.log	file has to end with '.log'
# -print		prints the files that were found 
# -delete		delete the filtered files 

find $PROJECTLOGS -mindepth 1 -maxdepth 3 -mtime +$MAXAGE -type f -name \*.log -print -delete


echo ""
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ RPI-SYNC END ]--------------------------------"
#"$(date +"%Y-%m-%dT%H:%M:%S.%3N") [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE












