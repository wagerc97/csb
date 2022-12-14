#!/bin/bash

#-----------------------------------------------------------------------------------------#
# Purpose
# This script will ask the user which configured remote storage ID ($REMOTECONFIG) should be un-mounted.
# (execute `$rclone config` to check wich remote storages are configured)
#
# Warning
# Execute this script only when NO OTHER CSB scripts are running!!!
#
# Recommended usage
#Use this script on demand to un-mount a remote storage.
#
# Part of the "cloud-storage-backup" project
# Author: Clemens Wager
# Last revisited: 2022-12-06
#-----------------------------------------------------------------------------------------#


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
echo ""

########################################################################

# Get the remote storage ID from user input 
read -r -p  "Which remote storage should be unmounted? Enter a name... " REMOTECONFIG
echo "You entered $REMOTECONFIG "
 
########################################################################



printf_current_timestamp
echo " [NOTICE ] Un-Mount '$REMOTECONFIG' "

fusermount -u $REMOTEMOUNTDIR || sudo umount -f $REMOTEMOUNTDIR || sudo umount -l $REMOTEMOUNTDIR 
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "
printf_current_timestamp
echo " [NOTICE ] Check if unmounted corectly "

# Check if the volume was really unmounted
#if [ -f $REMOTEMOUNTDIR/$MOUNTCHECK ]; then
if [ ! -n "$(find "REMOTEMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then

    printf_current_timestamp
    echo " [ ERROR ] Could not unmount remote storage volume '$REMOTECONFIG' "
    EXITCODE=1
else
    printf_current_timestamp
    echo " [SUCCESS] Remote storage volume '$REMOTECONFIG' was unmounted "
    EXITCODE=0
fi

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"

echo ""
read -r -p  "Press RETURN to continue ... " INPUT
echo "Bye "


exit $EXITCODE












