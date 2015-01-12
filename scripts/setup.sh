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
docker pull pierreozoux/haproxy
docker pull pierreozoux/confd
docker pull pierreozoux/email-forwarder
docker pull pierreozoux/nginx
docker pull pierreozoux/mysql
docker pull pierreozoux/wordpress
docker pull pierreozoux/known
ibuildthecloud/systemd-docker

# Install unit-files
sudo cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

# Create Directory structure
mkdir -p /data/domains
mkdir -p /data/import
mkdir -p /data/runtime/haproxy/approved-certs
mkdir -p /data/runtime/postfix

# Configure and start HAproxy
cp /data/indiehosters/scripts/unsecure-certs/indiehosters.dev.pem /data/runtime/haproxy/approved-certs/default.pem
systemctl enable confd.service
systemctl start  confd.service
systemctl enable haproxy.path
systemctl start  haproxy.path

# Configure and start postfix
touch /data/runtime/postfix/hostname
touch /data/runtime/postfix/destinations
touch /data/runtime/postfix/forwards

systemctl enable email-forwarder.service
systemctl start  email-forwarder.service

# Adds backup ssh key to the list of known hosts
ssh -o StrictHostKeyChecking=no `cat /data/BACKUP_DESTINATION` "exit"
