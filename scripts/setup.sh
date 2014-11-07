#!/bin/bash -eux

if [ $# -ge 1 ]; then
  HOSTNAME=$1
else
  echo "Usage: sh /data/indiehosters/scripts/setup.sh k1.you.indiehosters.net"
  exit 1
fi

# Install cloud-config
if [ -f /tmp/vagrantfile-user-data ]; then
  mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data
fi

# Pull relevant docker images
docker pull indiehosters/haproxy
docker pull indiehosters/confd
docker pull indiehosters/postfix-forwarder
docker pull indiehosters/nginx
docker pull indiehosters/mysql
docker pull indiehosters/wordpress

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

# Create Directory structure
mkdir -p /data/domains
mkdir -p /data/import
mkdir -p /data/runtime/haproxy/approved-certs
mkdir -p /data/runtime/postfix

# Configure and start HAproxy
cp /data/indiehosters/scripts/unsecure-certs/indiehosters.dev.pem /data/runtime/haproxy/approved-certs/default.pem
systemctl enable haproxy-confd.service
systemctl start  haproxy-confd.service
systemctl enable haproxy.path
systemctl start  haproxy.path

# Configure and start postfix
touch /data/runtime/postfix/hostname
touch /data/runtime/postfix/destinations
touch /data/runtime/postfix/forwards

systemctl enable postfix.service
systemctl start  postfix.service

# Adds backup ssh key to the list of known hosts
ssh -o StrictHostKeyChecking=no `cat /data/BACKUP_DESTINATION` "exit"
