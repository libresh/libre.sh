#!/bin/bash -eux

# Install cloud-config
mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull pierreozoux/haproxy-confd
docker pull tutum/mysql
docker pull tutum/wordpress-stackable
docker pull tutum/nginx

# Configure and start HAproxy
mkdir -p /data/server-wide/haproxy/approved-certs
cp /data/infrastructure/scripts/unsecure-certs/*.pem /data/server-wide/haproxy/approved-certs
systemctl enable haproxy.service
systemctl start  haproxy.service
