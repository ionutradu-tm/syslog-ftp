#!/bin/bash

mkdir -p /var/log/tmp
mkdir -p /var/log/remote

#run logrotate hourly
mv /etc/cron.daily/logrotate /etc/cron.hourly/

# start cron service
crontab /etc/crontab
service cron start

FTP_USER=integration
FTP_PORT=31021
FTP_REMOTE_FOLDER=upload/nginx
FTP_PASS=m8u;MVw7EqaEVx8Z
FTP_HOST=ftp.marathon.mesos

# prepare env variables
echo "#!/bin/bash" > /usr/local/bin/env.sh
echo "export FTP_USER=$FTP_USER" >>/usr/local/bin/env.sh
echo "export FTP_PASS=$FTP_PASS" >>/usr/local/bin/env.sh
echo "export FTP_HOST=$FTP_HOST" >>/usr/local/bin/env.sh
echo "export FTP_PORT=$FTP_PORT" >>/usr/local/bin/env.sh
echo "export FTP_REMOTE_FOLDER=$FTP_REMOTE_FOLDER" >>/usr/local/bin/env.sh
echo "export LOG_FILENAME=$LOG_FILENAME" >>/usr/local/bin/env.sh
if [[ -n $GREP_EXCLUDE_WORD ]]; then
   echo "export GREP_EXCLUDE_WORD=$GREP_EXCLUDE_WORD" >>/usr/local/bin/env.sh
fi

chmod +x /usr/local/bin/env.sh



# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n