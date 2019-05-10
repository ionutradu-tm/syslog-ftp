#!/bin/bash






mkdir -p /var/log/tmp
mkdir -p /var/log/remote
# start cron service
service cron start

# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n