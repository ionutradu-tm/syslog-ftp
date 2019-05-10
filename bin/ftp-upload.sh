#!/bin/bash

killall -HUP rsyncd

if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]] || [[ -z $FTP_REMOTE_FOLDER ]] || [[ -z $LOG_FILENAME ]] || [[ -z $FTP_PORT ]]; then
    echo "Please provide FTP_HOST, FTP_USER, FTP_PASS, FTP_REMOTE_FOLDER, LOG_FILENAME"
    exit 1
fi

LOG_TMP_FILE="/var/log/tmp/access.log-$(date +%Y-%m-%d-%T).gz"

if [[ -n GREP_EXCLUDE_WORD ]];
   then
      egrep -i -v $GREP_EXCLUDE_WORD $LOG_FILENAME | gzip > $LOG_TMP_FILE
   else
       mv  $LOG_FILENAME  $LOG_TMP_FILE

fi

# upload to FTP server

for FILE_UPLOAD in $(ls /var/log/tmp/*.gz
do
    curl -s -T $FILE_UPLOAD "ftp://${FTP_HOST}:${FTP_PORT}/${FTP_REMOTE_FOLDER}/" --user $FTP_USER:$FTP_PASS
    if [ $? -eq 0 ]; then
       echo "$FILE_UPLOAD sent to FTP server $FTP_HOST"
       rm $FILE_UPLOAD
    fi
done

