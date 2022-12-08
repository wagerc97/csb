#!/bin/bash


# source runs the files content and updates your workspace environment with it
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")

source ~/rpi-sync/src/config/envconfig.txt

echo "project dir von envonfig.txt: $PROJECTDIR"

echo""

source $PROJECTCONFIG/vars.txt

echo $VAR1$VAR1$VAR1$VAR1$VAR1$VAR1
echo $VAR2$VAR1
echo $VAR4

tmp=$VAR3
echo $tmp

tmp2=$((tmp+600+$VAR1))
echo $tmp2

tmp3=$(($tmp+$tmp2))
echo $tmp3

echo $VAR4

echo ""



