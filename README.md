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
sudo df -h
sudo du -sh /*
````
<img width="451" height="336" alt="Screenshot 2026-01-01 at 11 27 26 PM" src="https://github.com/user-attachments/assets/a5c4e070-3702-44a8-8337-60bb1a68f6bd" />

# 3. Process Monitoring
```bash
top
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10
````
<img width="852" height="380" alt="Screenshot 2026-01-01 at 11 28 48 PM" src="https://github.com/user-attachments/assets/7a2abd71-883b-4349-9262-9690f4032055" />

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
<img width="858" height="315" alt="Screenshot 2026-01-01 at 11 30 16 PM" src="https://github.com/user-attachments/assets/4888f6d3-2c0c-46fc-a6ec-35d731a7d62f" />

## Task 2: User Management

### 1. Create Users

```bash
sudo useradd sarah
sudo useradd mike
sudo passwd sarah
sudo passwd mike
````
<img width="444" height="99" alt="Screenshot-1" src="https://github.com/user-attachments/assets/0564cf09-4cc0-46d2-9490-8bab06de851e" />

### 2. Create Workspace Directories

```bash
sudo mkdir -p /home/sarah/workspace
sudo mkdir -p /home/mike/workspace

sudo chown -R sarah:sarah /home/sarah/workspace
sudo chown -R mike:mike /home/mike/workspace

sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace
````
<img width="443" height="267" alt="Screenshot-2" src="https://github.com/user-attachments/assets/61d643ed-70ab-42b5-9d8d-9e0428deadf0" />

### 3. Verify Directory Setup

```bash
ls -ld /home/sarah/workspace
ls -ld /home/mike/workspace
````
<img width="449" height="99" alt="Screenshot-3" src="https://github.com/user-attachments/assets/bb999ee8-a7de-4f79-90c6-05df0e6f5a37" />

#### Expected output:

```bash
drwx------ 2 sarah sarah ... /home/sarah/workspace
drwx------ 2 mike  mike  ... /home/mike/workspace
````
<img width="458" height="116" alt="Screenshot-4" src="https://github.com/user-attachments/assets/e4c92abb-2c96-4e35-bcba-ee5ff73e28b5" />

### 4. Enforce Password Expiration Policy

```bash
sudo chage -M 30 sarah
sudo chage -M 30 mike
````
<img width="348" height="71" alt="Screenshot-5" src="https://github.com/user-attachments/assets/4e9af718-fe03-49f1-8942-7c1b081f0cfa" />

### 5. Verify Password Expiry Settings

```bash
sudo chage -l sarah
sudo chage -l mike
````
<img width="638" height="294" alt="Screenshot-6" src="https://github.com/user-attachments/assets/6e82d7e6-76e3-4687-95d8-079fb07662bf" />


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
