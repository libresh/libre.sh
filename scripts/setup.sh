#!/bin/bash -eux

# Install cloud-config
if [ -f /tmp/vagrantfile-user-data ]; then
  mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data
fi

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull indiehosters/haproxy
docker pull indiehosters/confd
docker pull indiehosters/postfix-forwarder
docker pull indiehosters/nginx

# Activate default domain
etcdctl set /services/default '{"app":"nginx", "hostname":"'$1'"}'

# Configure and start HAproxy
mkdir -p /data/server-wide/haproxy/approved-certs
systemctl enable haproxy.service
systemctl start  haproxy.service

# Configure and start postfix
mkdir -p /data/server-wide/postfix
touch /data/server-wide/postfix/hostname
touch /data/server-wide/postfix/destinations
touch /data/server-wide/postfix/forwards

systemctl enable postfix.service
systemctl start  postfix.service
