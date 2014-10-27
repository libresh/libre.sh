#!/bin/bash -eux

# Install cloud-config
if [ -f /tmp/vagrantfile-user-data ]; then
  mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/vagrantfile-user-data
fi

# Pull relevant docker images
docker pull indiehosters/haproxy
docker pull indiehosters/confd
docker pull indiehosters/postfix-forwarder
docker pull indiehosters/nginx

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Activate default domain
sh /data/indiehosters/scripts/activate-user.sh $1 nginx
etcdctl set /services/default '{"app":"nginx", "hostname":"'$1'"}'

# Configure and start HAproxy
mkdir -p /data/server-wide/haproxy/approved-certs
systemctl enable haproxy-confd.service
systemctl start  haproxy-confd.service
systemctl enable haproxy.path
systemctl start  haproxy.path

# Configure and start postfix
mkdir -p /data/server-wide/postfix
touch /data/server-wide/postfix/hostname
touch /data/server-wide/postfix/destinations
touch /data/server-wide/postfix/forwards

systemctl enable postfix.service
systemctl start  postfix.service
