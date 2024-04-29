vim system_cleanup.sh

#!/bin/bash

# Check if the current user is root
if [ "$(id -u)" -ne 0 ];
then
    echo "This script must be run by sudo user. Please run it with sudo or as root."
    exit 1
fi

# Directories and files to be cleaned
tmp_dirs=("/tmp" "/var/tmp")
log_files=("/var/log/messages" "/var/log/secure")

# Function to delete old files
delete_old_files() {
    local dir="$1"
    local days="$2"
    
    find "$dir" -type f -mtime +$days -exec rm -rf {} \;
}

# Clean temporary files
for tmp_dir in "${tmp_dirs[@]}";
do
    if [ -d "$tmp_dir" ];
    then
        echo "Clearing temporary directory: $tmp_dir"
        delete_old_files "$tmp_dir" 7 # Delete files older than 7 days
    fi
done

# Clean up old logs
for log_file in "${log_files[@]}";
do
    if [ -f "$log_file" ];
    then
        echo "Cleaning log file: $log_file"
        truncate -s 0 "$log_file" # Empty the contents of the file
    fi
done

# Running additional cleanup for RHEL/CentOS
if command -v yum &>/dev/null;
then
    yum clean all
fi

echo "System cleaning completed."
