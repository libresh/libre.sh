FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -q -y rsyslog && \
    rm -rf /var/lib/apt/lists/*

ADD haproxy /etc/logrotate.d/haproxy
ADD postfix /etc/logrotate.d/postfix

VOLUME [ "/dev", "/var/log" ]

ENTRYPOINT [ "rsyslogd", "-n" ]

