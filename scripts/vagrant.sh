#!/bin/bash -eux

# Install cloud-config file
mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/

# Install unit-files
cp /data/infrastructure/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Pull relevant docker images
docker pull tutum/mysql
docker pull tutum/wordpress-stackable

# Start wordpress service for user coreos (and create the user)
systemctl enable wordpress@coreos.service
systemctl start  wordpress@coreos.service

# Configure and start HAproxy
docker pull dockerfile/haproxy
mkdir -p /data/server-wide/haproxy
IP=`docker inspect --format {{.NetworkSettings.IPAddress}} wordpress-coreos`
sed s/%IP%/$IP/ /data/infrastructure/templates/haproxy.cfg > /data/server-wide/haproxy/haproxy.cfg
systemctl enable haproxy.service
systemctl start  haproxy.service
