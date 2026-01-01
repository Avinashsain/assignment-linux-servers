# System Monitoring, User Management, and Backup Setup

This guide covers **system monitoring**, **user management**, and **backup configuration** on a Linux system.

---

## Task 1: System Monitoring Setup

This task includes installing monitoring tools, checking disk and process usage, and creating an automated system metrics logging script.

### 1. Install Monitoring Tools

```bash
sudo yum install -y htop nmon
````

# Verify installation:

```bash
htop or nmon
````
<img width="1496" height="838" alt="Screenshot-7" src="https://github.com/user-attachments/assets/bf5206c5-f83d-4a16-adb7-777e6bed0396" />

# 2. Disk Monitoring Setup
```bash
df -h
du -sh /*
````
# 3. Process Monitoring
```bash
top
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
````
# 4. Create Logging for System Metrics
### 4.1 Create Log Directory
```bash
sudo mkdir -p /var/log/system_monitoring
sudo chown ec2-user:ec2-user /var/log/system_monitoring
````
### 4.2 Create Monitoring Script
```bash
nano ~/system_monitor.sh
````
### Paste:
```bash
#!/bin/bash
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "==== System Metrics at $DATE ====" >> /var/log/system_monitoring/metrics.log
uptime >> /var/log/system_monitoring/metrics.log
free -h >> /var/log/system_monitoring/metrics.log
df -h >> /var/log/system_monitoring/metrics.log
ps aux --sort=-%cpu | head -5 >> /var/log/system_monitoring/metrics.log
echo "=================================" >> /var/log/system_monitoring/metrics.log

````
### 4.3 Make Script Executable
```bash
schmod +x ~/system_monitor.sh
````
### 4.4 Run Script Manually
```bash
./system_monitor.sh
````
### 4.5 Verify Logs
```bash
cat /var/log/system_monitoring/metrics.log
````
## Task 2: User Management

### 1. Create Users

```bash
sudo useradd sarah
sudo useradd mike
sudo passwd sarah
sudo passwd mike

````
### 2. Create Workspace Directories

```bash
sudo mkdir -p /home/sarah/workspace
sudo mkdir -p /home/mike/workspace

sudo chown -R sarah:sarah /home/sarah/workspace
sudo chown -R mike:mike /home/mike/workspace

sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace

````
### 3. Verify Directory Setup

```bash
ls -ld /home/sarah/workspace
ls -ld /home/mike/workspace

````
#### Expected output:

```bash
drwx------ 2 sarah sarah ... /home/sarah/workspace
drwx------ 2 mike  mike  ... /home/mike/workspace

````
### 4. Enforce Password Expiration Policy

```bash
sudo chage -M 30 sarah
sudo chage -M 30 mike

````

### 5. Verify Password Expiry Settings

```bash
sudo chage -l sarah
sudo chage -l mike

````

## Task 3: Backup Configuration

### 1. Create Backup Directory

```bash
sudo mkdir -p /backups
sudo chmod 755 /backups

````
### 2. Create Backup Scripts
#### Sarah — Apache Backup

```bash
nano /home/sarah/apache_backup.sh

````

#### Paste:

```bash
#!/bin/bash
DATE=$(date +%F)

BACKUP_DIR="/home/sarah/backups"
mkdir -p $BACKUP_DIR
chown sarah:sarah $BACKUP_DIR
chmod 700 $BACKUP_DIR

BACKUP="$BACKUP_DIR/apache_backup_$DATE.tar.gz"
LOG_FILE="$BACKUP_DIR/apache_verify_$DATE.log"

APACHE_DIR="/etc/httpd"
if [ ! -d "$APACHE_DIR" ]; then
    APACHE_DIR="/etc/apache2"
fi

tar -czf $BACKUP $APACHE_DIR /var/www/html
tar -tzf $BACKUP > $LOG_FILE 2>&1

echo "Backup completed at $(date)" >> $LOG_FILE

````
#### Make it executable:

```bash
chmod +x /home/sarah/apache_backup.sh

````
#### Mike — Nginx Backup

```bash
nano /home/mike/nginx_backup.sh

````

#### Paste:

```bash
#!/bin/bash
DATE=$(date +%F)

BACKUP_DIR="/home/mike/backups"
mkdir -p $BACKUP_DIR
chown mike:mike $BACKUP_DIR
chmod 700 $BACKUP_DIR

BACKUP="$BACKUP_DIR/nginx_backup_$DATE.tar.gz"
LOG_FILE="$BACKUP_DIR/nginx_verify_$DATE.log"

NGINX_DIR="/etc/nginx"
if [ ! -d "$NGINX_DIR" ]; then
    echo "Nginx config directory not found!" > $LOG_FILE
    exit 1
fi

tar -czf $BACKUP $NGINX_DIR /usr/share/nginx/html
tar -tzf $BACKUP > $LOG_FILE 2>&1

echo "Backup completed at $(date)" >> $LOG_FILE

````
#### Make it executable:

```bash
chmod +x /home/mike/nginx_backup.sh

````

### 3. Setup Cron Jobs
#### Sarah:

```bash
sudo crontab -u sarah -e

````
#### Add:

```bash
0 0 * * 2 /home/sarah/apache_backup.sh

````
#### Mike:

```bash
sudo crontab -u mike -e

````
#### Add:

```bash
0 0 * * 2 /home/mike/nginx_backup.sh

````

#### Verify cron jobs:

```bash
sudo crontab -u sarah -l
sudo crontab -u mike -l

````
### 4. Test Backup Manually

```bash
sudo -u sarah /home/sarah/apache_backup.sh
sudo -u mike /home/mike/nginx_backup.sh

ls -lh /backups
cat /backups/apache_verify_*.log
cat /backups/nginx_verify_*.log
````

### 5. Verification

```bash
cat /backups/apache_verify_*.log
cat /backups/nginx_verify_*.log
````
