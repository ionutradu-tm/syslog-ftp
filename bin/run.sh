#!/bin/bash

mkdir -p /var/log/tmp
mkdir -p /var/log/remote

#run logrotate hourly
mv /etc/cron.daily/logrotate /etc/cron.hourly/

# start cron service
crontab /etc/crontab
service cron start


if [[ -z $FTP_HOST ]] || [[ -z $FTP_USER ]] || [[ -z $FTP_PASS ]] || [[ -z $FTP_REMOTE_FOLDER ]] || [[ -z $LOG_FILENAME ]] || [[ -z $FTP_PORT ]]; then
    echo "Please provide FTP_HOST, FTP_USER, FTP_PASS, FTP_REMOTE_FOLDER, LOG_FILENAME"
    exit 1
fi
# prepare env variables
echo "#!/bin/bash" > /usr/local/bin/env.sh
echo "export FTP_USER=\"$FTP_USER\"" >>/usr/local/bin/env.sh
echo "export FTP_PASS=\"$FTP_PASS\"" >>/usr/local/bin/env.sh
echo "export FTP_HOST=\"$FTP_HOST\"" >>/usr/local/bin/env.sh
echo "export FTP_PORT=\"$FTP_PORT\"" >>/usr/local/bin/env.sh
echo "export FTP_REMOTE_FOLDER=\"$FTP_REMOTE_FOLDER\"" >>/usr/local/bin/env.sh
echo "export LOG_FILENAME=\"$LOG_FILENAME\"" >>/usr/local/bin/env.sh
if [[ -n $GREP_EXCLUDE ]]; then
   echo "export GREP_EXCLUDE_WORD=\"$GREP_EXCLUDE\"" >>/usr/local/bin/env.sh
fi

chmod +x /usr/local/bin/env.sh

echo "!!! PLEASE RESTART NGINX INSTANCES !!!"

# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n