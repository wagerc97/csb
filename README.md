# Cloud Storage Backup (CSB)
## In short
A set of scripts that use [rclone](https://rclone.org/) to back up your cloud storage to a local storage device. 


## Purpose 
Easily configure your own backup service to periodically store your cloud data locally.  

## Requirements
This service was originally developed for Raspberry Pi. But any Linux/Unix system should be able to use it as intended.
<br> <br>
Use for example cronjobs to trigger the according scripts (see [MANUAL.txt](/MANUAL.txt)) and save any changes on your cloud storage automatically. 
There is an [example crontab file](/src/maintenance/example-crontab.txt) with recommended cronjobs.  
You will need: 
- linux server
- [rclone installation](https://rclone.org/downloads/)
- cronjob configuration

## Details
### Developed with focus on:
- good logging
- easy configuration
- good documentation

### About [Rclone](https://rclone.org/#about)
![alt text](https://rclone.org/img/logo_on_light__horizontal_color.svg)
[Wikipedia](https://en.wikipedia.org/wiki/Rclone) defines Rclone as "an open source, multi threaded, command line computer program to manage or migrate content on cloud and other high latency storage. (...)" 

### Note: 
I used shell scripts for the first time in a larger project, so I learned a lot along the way. If you encounter any mistakes please let me now ;)
