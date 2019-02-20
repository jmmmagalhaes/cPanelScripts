#!/bin/bash

#Reading remote server's IP, password and initializing the log file for this script.
read -p "Enter Remote Server's IP Address: " REMOTE_HOST
read -sp  "Enter Root Password: " PASSWORD
LOG_FILE=/opt/backup_and_transfer.log

#Adding timestamp into the log file.
date=`date`
echo -e "\n========================================================================================================\n
$date : Initializing backup creation and transfer
"\n========================================================================================================" > $LOG_FILE

#For loop to create backup, transfer to the destination via SCP and removing the backup in the source server to save disk space.
for USER in `\ls /var/cpanel/users/`;
 do
echo -e "Creating the backup of $USER\n" >> $LOG_FILE;
echo -e "\n========================================================================================================\n" >> $LOG_FILE;
/scripts/pkgacct $USER >> $LOG_FILE;
expect -c " 
   set timeout 1
   spawn scp /home/cpmove-$USER.tar.gz root@$REMOTE_HOST:/opt/
   expect yes/no { send yes\r ; exp_continue }
   expect password: { send $PASSWORD\r }
   expect 100%
   sleep 1
   exit
" >> $LOG_FILE;
echo -e "\n========================================================================================================\n" >> $LOG_FILE;
rm -vf /home/cpmove-$USER.tar.gz >> $LOG_FILE;
echo -e "\n========================================================================================================\n" >> $LOG_FILE;
done;
************************************************************************************************************
5. Run the file transfer.sh in the screen of the source server.
6. You can check the progress of this task in the log file /opt/backup_and_transfer.log.
