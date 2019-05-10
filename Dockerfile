FROM ubuntu:18.04

MAINTAINER Ionut Radu <iradu@iradu.ro>

# install packages
RUN apt-get update && \
    apt-get install -y cron logrotate rsyslog curl

#cleanup
RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/
ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

ADD etc/rsyslog.conf /etc/
ADD etc/remote /etc/logrotate.d/

EXPOSE 514/tcp
EXPOSE 514/udp

CMD "/usr/local/bin/run.sh"

