### [backup-now.sh](/src/scripts/control/backup-now.sh)
__Purpose__  
This script will check the connectivity to your local (i.e. external) storage device and to the internet.
Then the remote storage (i.e. onedrive) will be un-mounted and mounted.
Then all changes on the remote storage are copied to a local directory.

__Warning__  
- Execute this script only when NO OTHER CSB scripts are running!!!
- Files with the same name will be overwritten.

__Recommended usage__  
Use this script on demand to create a backup of the configured remote storage with on click.  
Check the logs for information on the execution.


### [daily-call-main.sh](/src/scripts/control/daily-call-main.sh)
__Purpose__  
This script will check the connectivity to your local (i.e. external) storage device and to the internet.
Then the remote storage (i.e. onedrive) will be un-mounted and mounted.
Then all changes on the remote storage are copied to a local directory.

__Warning__  
- Execute this script only when NO OTHER CSB scripts are running!!!
- Files with the same name will be overwritten.

__Recommended usage__   
Use this script with a scheduling service f.e. Cronjobs to create a backup of the configured remote storage automatically.
Check the logs for information on the execution.


### [reboot-call-main.sh](/src/scripts/control/reboot-call-main.sh)
__Purpose__  
This script will check the connectivity to your local (i.e. external) storage device and to the internet.
Then the remote storage (i.e. onedrive) will be un-mounted and mounted.
Then all changes on the remote storage are copied to a local directory.

__Warning__  
- Execute this script only when NO OTHER CSB scripts are running!!!
- Files with the same name will be overwritten.

__Recommended usage__   
Use this script whenever your server boots. Caution that no other CSB service start at the same time due to scheduling. 
This can be implemented with f.e. Cronjobs (@reboot)
Check the logs for information on the execution.


### [system-check-for-backup.sh](/src/scripts/control/system-check-for-backup.sh)
__Purpose__  
This script will check the connectivity to your local (i.e. external) storage device and to the internet.
Then the remote storage (i.e. onedrive) will be un-mounted and mounted. NO BACKUP will be created.

__Warning__  
- Execute this script only when NO OTHER CSB scripts are running!!!

__Recommended usage__  
Use this script on demand when you want to confirm that the system is configured correctly. 
If successful the next backup should work without any major issues. 
Check the logs for information on the execution.


### [unmount-this-remotestorage.sh](/src/scripts/control/unmount-this-remotestorage.sh)
__Purpose__  
This script will ask the user which configured remote storage ID ($REMOTECONFIG) should be un-mounted.   
(execute `$rclone config` to check wich remote storages are configured)

__Warning__  
- Execute this script only when NO OTHER CSB scripts are running!!!

__Recommended usage__  
Use this script on demand to un-mount a remote storage.
