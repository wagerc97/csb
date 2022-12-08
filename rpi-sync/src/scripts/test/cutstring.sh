#!/bin/bash


# store the current timestamp in a variable
ts=$(date +"%Y-%m-%dT%H:%M:%S.%3N")  

# echo "NAME(APACHE) STATUS(Not Running)"  | cut -d'(' -f3

# print to announce execution of script
echo "$ts [NOTICE ]  calling script.sh ... " 
# execute the script and log its output
echo $ts.log

tscut=$(echo "$ts" |cut -d'.' -f1)


echo $tscut.log
