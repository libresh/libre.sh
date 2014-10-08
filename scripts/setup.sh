#!/bin/bash -eux

# Install cloud-config
mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull tutum/mysql
docker pull tutum/wordpress-stackable
docker pull tutum/nginx

# Configure and start HAproxy
docker pull dockerfile/haproxy
mkdir -p /data/server-wide/haproxy/certs
touch /data/server-wide/haproxy/certs/list.txt
cp /data/infrastructure/templates/haproxy-*.part /data/server-wide/haproxy/
rm /data/server-wide/haproxy/*.part
#rm /etc/systemd/system/multi-user.target.wants/*
touch /data/server-wide/haproxy/certs.part
touch /data/server-wide/haproxy/frontends.part
touch /data/server-wide/haproxy/backends.part
hostname > /data/server-wide/haproxy/hostname.part
cp /data/infrastructure/templates/haproxy-*.part /data/server-wide/haproxy/
systemctl enable haproxy.service
systemctl start  haproxy.service
