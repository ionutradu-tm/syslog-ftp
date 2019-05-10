FROM ubuntu:18.04

MAINTAINER Ionut Radu <iradu@iradu.ro>

RUN apt-get update && \
    apt-get install -y cron logrotate rsyslog

ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ADD etc/rsyslog.conf /etc/

CMD "/usr/local/bin/run.sh"