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
echo ""
#########################################


printf_current_timestamp
echo " [NOTICE ] Un-Mount '$REMOTECONFIG' "

fusermount -u $REMOTEMOUNTDIR || sudo umount -f $REMOTEMOUNTDIR || sudo umount -l $REMOTEMOUNTDIR 
echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Done "
printf_current_timestamp
echo " [NOTICE ] Check if unmounted corectly "

# Check if the volume was really unmounted
if [ ! -n "$(find "$REMOTEMOUNTDIR" -maxdepth 0 -type d -empty 2>/dev/null)" ]; then    
    printf_current_timestamp
    echo " [ ERROR ] Could not unmount remote storage volume '$REMOTECONFIG' "
    EXITCODE=1
else
    printf_current_timestamp
    echo " [NOTICE ] $REMOTEMOUNTDIR is empty "
    printf_current_timestamp
    echo " [SUCCESS] Remote storage volume '$REMOTECONFIG' was unmounted "
    EXITCODE=0
fi

echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"
#echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") [NOTICE ] waiting for $BIGTIMEOUT seconds ..."
#sleep $BIGTIMEOUT
exit $EXITCODE












