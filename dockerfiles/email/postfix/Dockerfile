FROM debian:jessie

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

COPY install.sh install.sh

RUN chmod 755 /install.sh

VOLUME ["/etc/postfix", "/var/spool/mail", "/var/log"]

EXPOSE 25

CMD /install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

