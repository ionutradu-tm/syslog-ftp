#!/bin/bash

source /usr/local/bin/env.sh

if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]] || [[ -z $FTP_REMOTE_FOLDER ]] || [[ -z $LOG_FILENAME ]] || [[ -z $FTP_PORT ]]; then
    echo "Please provide FTP_HOST, FTP_USER, FTP_PASS, FTP_REMOTE_FOLDER, LOG_FILENAME"
    exit 1
fi

LOG_TMP_FILE="/var/log/tmp/access.log-$(date +%Y-%m-%d-%T).gz"

# test if the file exists
if [[ ! -f $LOG_FILENAME ]]; then
  exit 2
fi

if [[ -n $GREP_EXCLUDE ]];
   then
      egrep -i -v $GREP_EXCLUDE $LOG_FILENAME | gzip > $LOG_TMP_FILE
      rm -f $LOG_FILENAME
   else
       cat  $LOG_FILENAME | gzip > $LOG_TMP_FILE
       rm -f $LOG_FILENAME
fi

# upload to FTP server
for FILE_UPLOAD in $(ls /var/log/tmp/*.gz)
do
    curl -s -T $FILE_UPLOAD "ftp://${FTP_HOST}:${FTP_PORT}/${FTP_REMOTE_FOLDER}/" --user $FTP_USER:$FTP_PASS
    if [ $? -eq 0 ]; then
       echo "$FILE_UPLOAD sent to FTP server $FTP_HOST"
       rm $FILE_UPLOAD
    fi
done