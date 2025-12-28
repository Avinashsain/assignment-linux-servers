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
![System Metrics Screenshot](https://raw.githubusercontent.com/username/repo/main/screenshots/Screenshot-2025-12-28-11-31-47.png)


