#!/bin/bash




service cron start

mkdir -p /var/log/tmp
mkdir -p /var/log/remote


# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n