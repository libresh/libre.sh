FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# Install Haproxy.
RUN \
  apt-get update && \
  apt-get install -y haproxy && \
  rm -rf /var/lib/apt/lists/*

VOLUME ["/etc/haproxy"]
ENTRYPOINT ["haproxy"]
CMD ["-d", "-f", "/etc/haproxy/haproxy.cfg"]
EXPOSE 80
EXPOSE 443
