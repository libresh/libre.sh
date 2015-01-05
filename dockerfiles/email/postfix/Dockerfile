FROM debian:jessie
MAINTAINER Michiel de Jong <michiel@indiehosters.net>

# Borrows from https://docs.docker.com/articles/dockerfile_best-practices/
# Borrows from https://registry.hub.docker.com/u/previousnext/postfix
# Borrows from https://registry.hub.docker.com/u/catatnight/postfix

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& echo "postfix postfix/main_mailer_type string 'Internet site'" | debconf-set-selections \
	&& echo "postfix postfix/mailname string 'HOSTNAME.EXAMPLE.COM'" | debconf-set-selections \
	&& echo "postfix postfix/root_address string 'ROOTMAIL@EXAMPLE.COM'" | debconf-set-selections \
	&& apt-get install -q -y \
		postfix \
		rsyslog \
		supervisor \
	&& rm -rf /var/lib/apt/lists/*

COPY assets/install.sh /opt/install.sh

VOLUME ["/etc/postfix", "/var/spool/mail", "/var/log"]

EXPOSE 25

CMD /opt/install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
