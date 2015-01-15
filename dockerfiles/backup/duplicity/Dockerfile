FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
  export VERSION=0.7.01 && \
  apt-get update && \
  apt-get install -y wget python python-dev python-pip librsync-dev ncftp lftp rsync && \
  rm -rf /var/lib/apt/lists/* && \
  pip install --upgrade lockfile paramiko pycrypto && \
  cd /tmp/ && \
  wget https://launchpad.net/duplicity/0.7-series/$VERSION/+download/duplicity-$VERSION.tar.gz && \
  cd /opt/ && \
  tar xzvf /tmp/duplicity-$VERSION.tar.gz && \
  rm /tmp/duplicity-$VERSION.tar.gz && \
  cd duplicity-$VERSION && \
  ./setup.py install

ENTRYPOINT [ "/usr/local/bin/duplicity" ]

