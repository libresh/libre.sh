FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get install -q -y \
      python3 \
      mysql-client \
      wget curl && \
      rm -rf /var/lib/apt/lists/*

COPY editconf.py /opt/editconf.py
COPY mysql-check.sh /opt/mysql-check.sh
RUN chmod u+x /opt/editconf.py && \
    chmod u+x /opt/mysql-check.sh

