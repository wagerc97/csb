# Cloud Storage Backup (CSB) Service
## In short
A set of scripts that use [Rclone](#about-rclone) to back up your cloud storage to a local storage device. 
Ideal for automated usage as backup service running on a server or use it on demand with one click.

## Purpose
You do not have to worry about your remotely stored data getting lost, if you make backups from time to time. 
This project uses open-source software Rclone and a well documented set of Bash scripts to ease the process.  
Easily configure this program to create backups of your remote storage (Google Drive, OneDrive, etc.) and store your cloud-based data locally whenever you want.  

## Quick Install
__Step 1:__ Highlight and copy the command below.    
```shell
cd ~ | git clone https://github.com/wagerc97/csb.git
```

__Step 2:__ Paste the command in a terminal session on your server and execute.  
__Step 3:__ [install Rclone](https://rclone.org/install/) in your home directory     
__Step 4:__ configure CSB installation according to [INSTALLATION](/howto/INSTALLATION.txt)   

## Details
### Developed with focus on:
- good logging
- good documentation
- easy configuration

__Check out the detailed [script documentation](/src/scripts/control) for each service to learn more!__

## Recommended use case
### Automated backup service
Use for example cronjobs to trigger the according scripts (see [manual](/howto/MANUAL.txt)) and save any changes on your cloud storage automatically. 
There is an [example crontab file](/src/maintenance/example-crontab.txt) with recommended cronjobs.  
You will need: 
- linux system
- [Rclone installation](https://rclone.org/install/)
- cronjob configuration

More details about the installation of the CSB service can be read in the [installation](/howto/INSTALLATION.txt) guideline.

Note: This service was originally developed for Raspberry Pi. But any Linux/Unix system should be able to use it as intended.

## About 

<img align="right" src="https://rclone.org/img/logo_on_light__horizontal_color.svg" width="200" height="100" >

### Rclone 
[Wikipedia](https://en.wikipedia.org/wiki/Rclone) defines [Rclone](https://rclone.org/#about) as "an open source, multi threaded, command line computer program to manage or migrate content on cloud and other high latency storage. (...)"  

### Acknowledgement
Thanks [@pageauc](https://github.com/pageauc) for providing a nice Rclone installation repository ([rclone4pi](https://github.com/pageauc/rclone4pi)). It helped me to get into this topic. 

### Note 
This is the first time I used shell scripts in a project, so I learned a lot along the way. If you encounter any mistakes please let me know and I will fix it in the repo ;-)
