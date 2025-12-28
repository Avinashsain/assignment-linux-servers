#!/bin/bash
DATE=$(date +%F)

# Use Sarah's home backups folder
BACKUP_DIR="/home/sarah/backups"
mkdir -p $BACKUP_DIR
chown sarah:sarah $BACKUP_DIR
chmod 700 $BACKUP_DIR

BACKUP="$BACKUP_DIR/apache_backup_$DATE.tar.gz"
LOG_FILE="$BACKUP_DIR/apache_verify_$DATE.log"

# Check Apache folder path
APACHE_DIR="/etc/httpd"
if [ ! -d "$APACHE_DIR" ]; then
    APACHE_DIR="/etc/apache2"
fi

# Create backup
tar -czf $BACKUP $APACHE_DIR /var/www/html

# Verify backup and save log
tar -tzf $BACKUP > $LOG_FILE 2>&1

echo "Backup completed at $(date)" >> $LOG_FILE