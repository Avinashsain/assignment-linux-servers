# Task 1: System Monitoring Setup

This task covers installing monitoring tools, checking disk and process usage, and creating an automated system metrics logging script.

---

## Install Monitoring Tools

1. Install required monitoring utilities:

```bash
sudo yum install -y htop nmon
Verify installation:

htop or nmon 
2. Disk Monitoring Setup
Check disk usage:

df -h
du -sh /*

3. Process Monitoring
View running processes and resource usage:

top
ps aux --sort=-%cpu | head -10
ps aux --sort=-%mem | head -10

4. Create Logging for System Metrics
4.1 Create Log Directory
sudo mkdir -p /var/log/system_monitoring
sudo chown ec2-user:ec2-user /var/log/system_monitoring

4.2 Create Monitoring Script
Create the script file:

nano ~/system_monitor.sh
Paste the following content:

#!/bin/bash
DATE=$(date '+%Y-%m-%d %H:%M:%S')

echo "==== System Metrics at $DATE ====" >> /var/log/system_monitoring/metrics.log
uptime >> /var/log/system_monitoring/metrics.log
free -h >> /var/log/system_monitoring/metrics.log
df -h >> /var/log/system_monitoring/metrics.log
ps aux --sort=-%cpu | head -5 >> /var/log/system_monitoring/metrics.log
echo "=================================" >> /var/log/system_monitoring/metrics.log
4.3 Make Script Executable

chmod +x ~/system_monitor.sh
4.4 Run Script Manually

./system_monitor.sh
4.5 Verify Logs

View the log output:

cat /var/log/system_monitoring/metrics.log!


# Task 2: User Management

This document describes the steps to create development users, configure secure workspaces, and enforce a password expiration policy on a Linux system.

---

```bash
1. Create two users: **sarah** and **mike**.
sudo useradd sarah
sudo useradd mike
Set passwords for both users:

sudo passwd sarah
sudo passwd mike

2. Create Workspace Directories
Create personal workspace directories for each user.

sudo mkdir -p /home/sarah/workspace
sudo mkdir -p /home/mike/workspace
Assign ownership to respective users:

sudo chown -R sarah:sarah /home/sarah/workspace
sudo chown -R mike:mike /home/mike/workspace
Set permissions so that only the owner can access the workspace:

sudo chmod 700 /home/sarah/workspace
sudo chmod 700 /home/mike/workspace

3. Verify Directory Setup
Verify ownership and permissions:

ls -ld /home/sarah/workspace
ls -ld /home/mike/workspace
Expected output format:

drwx------ 2 sarah sarah ... /home/sarah/workspace
drwx------ 2 mike  mike  ... /home/mike/workspace

4. Enforce Password Expiration Policy
Set password expiration to 30 days:

sudo chage -M 30 sarah
sudo chage -M 30 mike

5. Verify Password Expiry Settings
Check password policy for each user:

sudo chage -l sarah
sudo chage -l mike

You should see output indicating that the password expires every 30 days.
