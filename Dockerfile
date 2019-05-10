FROM ubuntu:18.04

MAINTAINER Ionut Radu <iradu@iradu.ro>



ADD ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*.sh

CMD "/usr/local/bin/run.sh"