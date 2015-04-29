FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Install Haproxy.
RUN \
  apt-get update && \
  apt-get install -y \
    haproxy \
    rsyslog && \
  rm -rf /var/lib/apt/lists/*

ADD run.sh /run.sh

CMD ["/run.sh"]
EXPOSE 80
EXPOSE 443

