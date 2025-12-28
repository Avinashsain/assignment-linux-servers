#!/bin/bash
DATE=$(date +%F)

# Use Mike's home backups folder
BACKUP_DIR="/home/mike/backups"
mkdir -p $BACKUP_DIR
chown mike:mike $BACKUP_DIR
chmod 700 $BACKUP_DIR

BACKUP="$BACKUP_DIR/nginx_backup_$DATE.tar.gz"
LOG_FILE="$BACKUP_DIR/nginx_verify_$DATE.log"

# Check Nginx folder path
NGINX_DIR="/etc/nginx"
if [ ! -d "$NGINX_DIR" ]; then
    echo "Nginx config directory not found!" > $LOG_FILE
    exit 1
fi

# Create backup
tar -czf $BACKUP $NGINX_DIR /usr/share/nginx/html

# Verify backup and save log
tar -tzf $BACKUP > $LOG_FILE 2>&1

echo "Backup completed at $(date)" >> $LOG_FILE