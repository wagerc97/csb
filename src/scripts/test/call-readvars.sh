#!/bin/bash


echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo ""

# source runs the files content and updates your workspace environment with it
source ~/csb/src/config/envconfig.txt

echo "project dir von envonfig.txt: $PROJECTDIR"
echo "project scripts von envonfig.txt: $PROJECTSCRIPTS"
echo ""
printf $PROJECTSCRIPTS



ts=$(date +"%Y-%m-%dT%H:%M:%S.%3N")  
$PROJECTSCRIPTS/test/readvars.sh >> $PROJECTSCRIPTS/test/log/sourcing-$ts.log 2>&1

### LEARNING: source is a bash command so you cannot call it in a file that was called with 'sh'. Sh -> shell has no source command 
