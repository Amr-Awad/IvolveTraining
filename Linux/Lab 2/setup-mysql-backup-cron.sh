#!/bin/bash

# Variables
STUDENT_USER="student"
BACKUP_DIR="/home/$STUDENT_USER/mysql_backups"
CRON_JOB="0 5 * * 0 sudo -u $STUDENT_USER /usr/bin/mysqldump --all-databases > $BACKUP_DIR/all-databases-\$(date +\%F).sql"

echo "Installing MySQL Server..."
sudo yum install -y mysql-server

echo "Enabling and starting MySQL service..."
sudo systemctl enable mysqld
sudo systemctl start mysqld

echo "Granting 'student' user access to MySQL..."
sudo usermod -aG mysql $STUDENT_USER

echo "Creating backup directory with correct permissions..."
sudo mkdir -p "$BACKUP_DIR"
sudo chown -R $STUDENT_USER:$STUDENT_USER "$BACKUP_DIR"
sudo chmod 700 "$BACKUP_DIR"

echo "Adding sudo rule to allow student to run mysqldump without a password..."
echo "$STUDENT_USER ALL=(ALL) NOPASSWD: /usr/bin/mysqldump" | sudo tee /etc/sudoers.d/student_mysql

echo "Adding cron job to run as root but execute mysqldump as student..."
(sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sudo crontab -

echo "Setup complete! MySQL backup will run every Sunday at 5 AM."
