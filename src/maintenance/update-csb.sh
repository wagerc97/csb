#!/bin/bash
#-----------------------------------------------------------------------------------------#
# This script deletes the CSB installation and clones the uptodate version from my repo.
# (https://github.com/wagerc97/csb.git)
# CAUTION!!! local csb configurations and changes will be destroyed
# Author: Clemens Wager
# Last revisited: 2022-12-08
#-----------------------------------------------------------------------------------------#

echo "-----------------------------------[ CSB  START ]-------------------------------"
echo "bash version: $BASH_VERSION "
echo $(basename "$0") "|" $(date +"%Y-%m-%dT%H:%M:%S.%3N")
echo ""

#########################################
############ Define Variables ###########

# define variables
CSBSYSCONFIG=~/csb/src/config/envconfig.sh


echo "[ CAUTION ] "
echo "This script will delete all local CSB configurations and changes in ~/csb "
echo "You will have to reconfigure a view parameters in '$CSBSYSCONFIG' "
echo "Your local backup data will not be influenced by this "
echo ""
read -r -p  "Do you want to continue? (Y)es or (N)o? " INPUT

# Check user input and proceed accordingly
case $INPUT in
########################################################################
	[yY][eE][sS]|[yY])
		echo ""
		echo "You answered '$INPUT'. Proceeding to update CSB installation... "
		echo ""

		# change directory
		echo "Switch to ~\ directory: "
		cd ~
		pwd

		# remove the old CSB installation
		echo "Remove old installation"
		rm -rf ~/csb

		sleep 2

		# git clone from main branch (default branch that works)
		git clone --branch main https://github.com/wagerc97/csb.git
		# Only for DEVELOPMENT
		#git clone --branch develop https://github.com/wagerc97/csb.git

		sleep 2
		# Ensure log folders exist otherwise create them
    echo "Ensure all log folders exist "
    mkdir -pv ~/csb/logs
    mkdir -pv ~/csb/logs/control
    mkdir -pv ~/csb/logs/control/main
    mkdir -pv ~/csb/logs/control/systemcheck
    mkdir -pv ~/csb/logs/control/daily
    mkdir -pv ~/csb/logs/control/ondemand
    mkdir -pv ~/csb/logs/control/reboot
    mkdir -pv ~/csb/logs/single
    mkdir -pv ~/csb/logs/single/check-web
    mkdir -pv ~/csb/logs/single/check-usb
    mkdir -pv ~/csb/logs/single/unmount
    mkdir -pv ~/csb/logs/single/mount
    mkdir -pv ~/csb/logs/single/backup
		sleep 1

		# give permission to scripts
		echo "Modify execution permissions of CSB scripts"
		chmod -R +x ~/csb/

		sleep 1

		echo ""
		echo "Finished! "
		;;
########################################################################

	[nN][oO]|[nN])
		echo "..."
		echo "You answered '$INPUT'. Quit $(basename "$0")... "
		EXITCODE=0
		;; # end of NO
	*)
		echo "..."
		echo "Your answer '$INPUT' was invalid. Please type 'yes' or 'no' next time. "
		EXITCODE=1
		;; # end of default
esac
########################################################################

echo ""
echo "I recommend reconfiguring the environment variables in '$CSBSYSCONFIG' "
echo "Then start a system check to check the installation "
echo ""


echo "$(date +"%Y-%m-%dT%H:%M:%S.%3N") | Bye "
echo "------------------------------------[ CSB  END ]--------------------------------"
echo ""
read -r -p  "Press RETURN to continue ... " INPUT
echo "Bye "

exit $EXITCODE
