#!/bin/bash

# Author: Megdalia Bromhal
# Date: 7 Nov. 2023
# Section: CIT 225

# Script Description: This script backs up all the files stores in a personal
# data directory /home/<username>/data. All the backup files are stored in a
# personal backup directory /home/<username>/backups as .tar.gz files.

# References: 
# https://superuser.com/questions/805127/including-timestamp-in-file-name
# https://www.geeksforgeeks.org/md5sum-linux-command/
# https://linuxconfig.org/how-to-append-to-file-on-bash-shell-command-line

# Assigning the home directory and data folder to back up
homeData=$HOME/data

# If there isn't a data directory to back up
if [ ! -e "$homeData" ]
then
        # Then exit with message
        printf "No data directory to back up.\n"
        exit 0
fi

# Making sure the target directory and file(s) exist
if [ -e "$homeData" ] && [ -s "$homeData" ]
then

        # Making the backup directory /home/<username>/backups if doesn't already exist
        backupDir=$HOME/backups

        if [ ! -e "$backupDir" ] || [ ! -d "$backupDir" ]
        then
                # If directory doesn't exist
                printf "Backup directory doesn't exist; making directory...\n"
                mkdir "$backupDir"
        fi

        # Checking if checksum file exists
        if [ ! -e "$backupDir"/checksums.txt ]
        then
                # If it doesn't exist, make it
                printf "Checksum file doesn't exist; creating file...\n"
                touch "$backupDir"/checksums.txt
        fi

        # Compress files as .tar.gz
        # Name backup tar files "data-backup-YYYY-MM-DD.tar.gz" with YYYY-MM-DD is the current date
        printf "Compressing files in data directory to a tar.gz file...\n"
        tar czf "$backupDir"/data-backup-"$(date +"%Y-%m-%d")".tar.gz -C "$homeData" .

        # Create an MD5 checksum value for the tar.gz backup file and store in a file called checksums.txt in the backup directory

        # Store md5 checksum in a file
        #md5sum $homeDir > checksums.txt
        printf "Placing md5 checksum in checksums.txt file in backups directory...\n"
        md5sum "$backupDir"/data-backup-"$(date +"%Y-%m-%d")".tar.gz >> "$backupDir"/checksums.txt

        printf "\nBackup complete. Please see 'backups' directory for compressed files and checksums.\n"
        exit 0
fi

# EOF