#!/bin/bash -eux

# Install cloud-config
if [ -f /tmp/vagrantfile-user-data ]; then
  mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data
fi

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull indiehosters/haproxy-confd
docker pull indiehosters/mysql
docker pull indiehosters/wordpress
docker pull indiehosters/nginx

# Configure and start HAproxy
mkdir -p /data/server-wide/haproxy/approved-certs
cp /data/infrastructure/scripts/unsecure-certs/*.pem /data/server-wide/haproxy/approved-certs
systemctl enable haproxy.service
systemctl start  haproxy.service
