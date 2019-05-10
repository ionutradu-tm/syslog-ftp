#!/bin/bash

mkdir -p /var/log/tmp
mkdir -p /var/log/remote

#run logrotate hourly
mv /etc/crond.daily/logrotate /etc/cron.hourly/
# start cron service
service cron start

# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n