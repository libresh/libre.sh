FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update &&\
  apt-get install -y \
    wget \
    ca-certificates &&\
  rm -rf /var/lib/apt/lists/*

RUN \
  wget https://github.com/kelseyhightower/confd/releases/download/v0.6.3/confd-0.6.3-linux-amd64 -O confd && \
  chmod +x confd

RUN \
  wget https://get.docker.com/builds/Linux/x86_64/docker-1.2.0 -O docker && \
  chmod +x docker

VOLUME ["/etc/confd/", "/etc/haproxy"]
ENTRYPOINT ["/confd"]
CMD ["-interval=60", "-node=172.17.42.1:4001"]
