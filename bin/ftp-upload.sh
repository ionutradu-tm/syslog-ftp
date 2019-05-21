#!/bin/bash

source /usr/local/bin/env.sh

if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]] || [[ -z $FTP_REMOTE_FOLDER ]] || [[ -z $LOG_FILENAME ]] || [[ -z $FTP_PORT ]]; then
    echo "Please provide FTP_HOST, FTP_USER, FTP_PASS, FTP_REMOTE_FOLDER, LOG_FILENAME"
    exit 1
fi

LOG_TMP_FILE="/var/log/tmp/access.log-$(date +%Y-%m-%d-%T).gz"

# SMTP
export SEND_EMAIL=0
if [[ -n $SMTP_TO ]] && [[ -n SMTP_SERVER ]] && [[ -n SMTP_PORT ]] && [[ -n SMTP_FROM ]]; then
    export SEND_EMAIL=1
fi

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
       export uploaded = 1
       echo "$FILE_UPLOAD uploaded to FTP server $FTP_HOST" >>/body_mail_succes.txt
    else
       export fail_upload = 1
       echo "$FILE_UPLOAD not uploaded to FTP server $FTP_HOST" >>/body_mail_fail.txt
    fi
done

if [[ "$SEND_EMAIL" -eq "1" ]]; then
    if [[ "$uploaded" -eq "1" ]];then
           curl -v --connect-timeout 15 --insecure "smtp://$SMTP_SERVER:$SMTP_PORT" --mail-from $SMTP_FROM --mail-rcpt $SMTP_TO   -T /body_mail_succes.txt
    fi
    if [[ "$fail_upload" -eq "1" ]];then
           curl -v --connect-timeout 15 --insecure "smtp://$SMTP_SERVER:$SMTP_PORT" --mail-from $SMTP_FROM --mail-rcpt $SMTP_TO   -T /body_mail_fail.txt
    fi
fi