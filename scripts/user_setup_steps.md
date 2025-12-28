# Linux User Setup and Security Policy

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