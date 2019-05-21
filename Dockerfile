FROM ubuntu:18.04

MAINTAINER Ionut Radu <iradu@iradu.ro>

# install packages
RUN apt-get update && \
    apt-get install -y  apt-utils cron logrotate rsyslog curl psmisc

#cleanup
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

RUN rm -f /etc/logrotate.d/*
ADD etc/rsyslog.conf /etc/
ADD etc/remote /etc/logrotate.d/
ADD etc/crontab /etc/
ADD etc/body_mail_fail.txt /
ADD etc/body_mail_succes.txt /

EXPOSE 514/tcp
EXPOSE 514/udp

CMD "/usr/local/bin/run.sh"

