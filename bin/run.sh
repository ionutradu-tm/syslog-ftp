#!/bin/bash


#delete default rsyslog conf

service cron start


# Run RSyslog daemon
exec /usr/sbin/rsyslogd -n