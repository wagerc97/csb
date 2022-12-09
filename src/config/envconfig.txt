##################################################################################
# envconfig.sh
# This file stores environment variables for the cloud-storage-backup (CSB) project
# Usage:
#  - import variables with 'source ~/cloud-storage-backup/src/config/envconfig.sh'
#	 (bash will run this file like a .sh file and thus create the variables and 
#    also execute everything that is written here)
#  - variables that are defined here can then be used normally 
# Author: Clemens Wager
# Last revisited: 2022-12-06
##################################################################################



#============================[ NEEDS INITIAL CONFIGURATION ]======================

##############
#   RCLONE   #
##############

# rclone configuration id of remote storage
REMOTECONFIG=personalod

# Name of your local storage device 
LOCALSTORAGEDEVICENAME=bigstick

#==================================================================================







#########################################################################
#########################################################################
###	 															      ###
###  DO NOT CHANGE THESE IF YOU ARE NOT 100% SURE WHAT YOU ARE DOING  ###
###	 															      ###
#########################################################################
#########################################################################


##############
#  BOOLEANS  #
##############

# (DEFAULT) Boolean indicates if rclone copy logs individually in $PROJECTLOGS/backup/copy-<ts>.log (default=TRUE)
# 0 == TRUE  ;  1 == FALSE
LOGBACKUP=0


##############
#   VALUES   #
##############

# (DEFAULT) Maximum age in DAYS for logfiles storage (recommend 30 days)
MAXAGE=30


##############
#   MOUNTS   #
##############

# (DEFAULT) where to mount the remote storage (default=cloud) 
REMOTEMOUNTDIR=/mnt/pi/cloud 

# Location and name of mounted USB stick 
USBMOUNTDIR=/media/pi/$LOCALSTORAGEDEVICENAME


##############
#   RCLONE   #
##############

# (DEFAULT) Local folder on local storage device. Rclone will store your data here(=destination)
DESTDIR=/media/pi/$LOCALSTORAGEDEVICENAME/localbackup

# The Remote storage id as named in rclone.config (=source)
# ... the ':' is necessary at the end
SOURCEDIR=$REMOTECONFIG:

# Location of rclone config file 
# Note: at least if rclone is installed in user's home directory
RCLONECONFIG=~/.config/rclone/rclone.conf


#############
#   PATHS   #
#############

# location of project root
#PROJECTDIR=~/cloud-storage-backup
PROJECTDIR=~/csb

# location of project scripts
PROJECTRESOURCES=$PROJECTDIR/resources

# location of project scripts
PROJECTSRC=$PROJECTDIR/src

# location of project scripts
PROJECTSCRIPTS=$PROJECTSRC/scripts

# location of project config for source code 
PROJECTCONFIG=$PROJECTSRC/config

# location of project logs
PROJECTLOGS=$PROJECTDIR/logs

# location of project logs for smaller scripts
PROJECTLOGSSINGLE=$PROJECTLOGS/single

# location of project logs for controlling scripts
PROJECTLOGSCONTROL=$PROJECTLOGS/control

#############
#   FILES   #
#############

# to check if file recognised by system and mount was successful
CHECKFILENAME=tmpmountcheck.txt
USBCHECKFILE=$PROJECTRESOURCES/$CHECKFILENAME

# Path to the .txt file holding filter rules for rclone copy
FILTERLIST=$PROJECTCONFIG/filter-list.txt

