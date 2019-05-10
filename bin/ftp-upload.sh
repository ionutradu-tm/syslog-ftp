#!/bin/bash


if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]] || [[ -z $FTP_REMOTE_FOLDER ]] || [[ -z $LOG_FILENAME ]]; then
    echo "Please provide FTP_HOST, FTP_USER, FTP_PASS, FTP_REMOTE_FOLDER, LOG_FILENAME"
    exit (1)
fi

LOG_TMP_FILE="/var/log/tmp/access.log-(date +%Y-%m-%d).gz"

if [[ -n GREP_EXCLUDE_WORD ]];
   then
      grep -i -v $GREP_EXCLUDE_WORD $LOG_FILENAME | gzip > $LOG_TMP_FILE
   else
       mv  $LOG_FILENAME  $LOG_TMP_FILE

fi

