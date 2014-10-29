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
docker pull indiehosters/wordpress-subdir

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system
systemctl daemon-reload

# Activate default domain
sh /data/indiehosters/scripts/activate-user.sh $HOSTNAME nginx
etcdctl set /services/default '{"app":"nginx", "hostname":"'$HOSTNAME'"}'

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
