#!/bin/bash

echo "bash version: $BASH_VERSION "
#bash version: 5.0.3(1)-release 


#printf "printf $(date +"%Y-%m-%dT%H:%M:%S.%3N") \
#[SUCCESS] blabla \n"

#echo "echo $(date +"%Y-%m-%dT%H:%M:%S.%3N") \
#[SUCCESS] blabla"


# output script name
#echo "$(basename "$0") | $(date +"%Y-%m-%dT%H:%M:%S.%3N") "
# ==
#echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

list=( 
	unmount 
	backup
	hudn 
	katze 
	maus
)

for l in "${list[@]}"; do
	echo "$l"
done


















