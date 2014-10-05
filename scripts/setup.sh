#!/bin/bash -eux

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull tutum/mysql
docker pull tutum/wordpress-stackable
docker pull tutum/nginx

# Configure and start HAproxy
docker pull dockerfile/haproxy
mkdir -p /data/server-wide/haproxy
cp /data/infrastructure/templates/haproxy-main.part /data/server-wide/haproxy/haproxy-main.part
rm /data/server-wide/haproxy/frontends.part
rm /data/server-wide/haproxy/backends.part
systemctl enable haproxy.service
systemctl start  haproxy.service
