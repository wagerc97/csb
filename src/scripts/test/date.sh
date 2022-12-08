#!/bin/bash
ver="1.6"


### timestamp=$(date +"%Y-%m-%dT%H:%M:%S.%3N") ### 2022-11-16T13:05:07.647
timestamp=$(date +"%Y-%m-%dT%H:%M:%S.%3N")
#echo $timestamp

# comined output
#printf "REBOOT %s" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

###################################################


#df='%Y-%m-%dT %H:%M:%S.%3N'
#timestamp=$(date + "$@df")

#echo $(date)
#Wed 16 Nov 2022 12:43:30 PM CET


#echo -n "REBOOT "
#echo $(date +"%Y-%m-%dT %H:%M:%S.%3N")

printf "date.sh mit ts %s\n" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo "+ ein hallo von date.sh"

