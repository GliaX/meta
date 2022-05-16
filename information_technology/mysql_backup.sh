#!/bin/bash
## Designed to run in Synology DSM > Control Panel > Task Scheduler > User-defined script
# For more information and rationale, see the following thread: https://community.synology.com/enu/forum/1/post/143095?page=1&reply=475634
# This script will backup MYSQL databases. One script is needed for each database.
#
# Errors will be sent back if any are found during backup.

################################################################
DB_BACKUP_PATH='/backups/sql'
MYSQL_HOST='server'
MYSQL_PORT='port'
MYSQL_USER='user'
MYSQL_PASSWORD='password'
DATABASE_NAME='db'

MYSQLDUMP=/volume1/@appstore/MariaDB10/usr/local/mariadb10/bin/mysqldump
## Get this file by installing the MariaDB package in Synology package manager (it doesn't need to actually run)
#################################################################
echo "Backup started for database: ${DATABASE_NAME}"

$MYSQLDUMP -h ${MYSQL_HOST} \
-P ${MYSQL_PORT} \
-u ${MYSQL_USER} \
-p${MYSQL_PASSWORD} \
--single-transaction \
--max_allowed_packet=512M \
${DATABASE_NAME} | xz > ${DB_BACKUP_PATH}/${DATABASE_NAME}.sql.xz

ERRORCODE=${PIPESTATUS[@]}

if [ `test ${ERRORCODE[0]} -eq 0 -a ${ERRORCODE[1]} -eq 0` ]; then
echo "Database backup successfully completed"
else
echo ${ERRORCODE[@]}
echo "Error found during backup"
exit 1
fi
### End of script ####
