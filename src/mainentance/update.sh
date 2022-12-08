#!/bin/bash

#-----------------------------------------------------------------------------------------#
# this file does... IS UNDER CONSTRUCTION
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
source ~/cloud-storage-backup/src/config/envconfig.txt


# process variables
TIMESTAMP=$(date +"%Y-%m-%dT%H:%M:%S.%3N") 
SMALLTIMEOUT=1
BIGTIMEOUT=3
EXITCODE=0
#########################################
############ Define Functions ###########

printf_current_timestamp() { 
	# This function prints the current timestamp without newline
	printf $(date +"%Y-%m-%dT%H:%M:%S.%3N")
}

#########################################


# pull from repo

# create all logs folders 


# give permissions
#$ chmod -R +x ~/cloud-storage-backup/

# write cronjobs upon first installation ???
#cat initialcronjobs > cronjob -e



#########################################

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"

# for debugging
#echo "start time: $ts"
#echo "  end time: $tsend"
# for debugging: deletes the just copied files and folder
#rm -rf $DESTDIR 

exit $EXITCODE
