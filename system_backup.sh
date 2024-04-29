#!/bin/bash

# There are many back up tools tu use for each specific need. I chose to use rsync.

# Check if current user is sudo
if [ "$(id -u)" -ne 0 ];
then
    echo "This script must be run with sudo privileges."
    exit 1
fi

# Directory where backups will be stored
backup_dir="/var/backups"

# Backup file name
backup_fileN="backup-$(date +%Y%m%d%H%M%S).tar.gz"

# Create backup directory if it does not exist
mkdir -p "$backup_dir"

# Perform backup using rsync
rsync -av --exclude="$backup_dir" --exclude=/proc --exclude=/sys --exclude=/dev --exclude=/run --exclude=/mnt --exclude=/media --exclude=/lost+found --exclude=/tmp --exclude=/var/tmp --exclude=/var/run / "$backup_dir/$backup_fileN"

# Verify if the backup was performed correctly
if [ "$?" -eq 0 ];
then
    echo "Full backup successfully completed: $backup_fileN"
fi

else
    echo "Backup failed"
fi
