#!/bin/bash -eux

/usr/bin/coreos-cloudinit --from-file=/var/lib/coreos-install/user_data

docker pull pierreozoux/rsyslog
docker pull pierreozoux/haproxy
docker pull pierreozoux/confd
docker pull pierreozoux/postfix
#docker pull pierreozoux/dovecot
docker pull pierreozoux/nginx
docker pull pierreozoux/mysql
docker pull pierreozoux/wordpress
docker pull pierreozoux/known
docker pull pierreozoux/piwik
docker pull pierreozoux/owncloud
docker pull pierreozoux/duplicity
docker pull ibuildthecloud/systemd-docker

# Create Directory structure
mkdir -p /data/domains
mkdir -p /data/runtime/haproxy/approved-certs
git clone https://github.com/pierreozoux/IndiePaaS.git /data/indiehosters

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

# Configure and start HAproxy
cp /data/indiehosters/tests/unsecure-certs/indiehosters.dev.pem /data/runtime/haproxy/approved-certs/default.pem

systemctl enable rsyslog
systemctl start  rsyslog
systemctl enable postfix
systemctl start  postfix
systemctl enable confd
systemctl start  confd
systemctl enable haproxy.path
systemctl start  haproxy.path

# Import backup encryption key
gpg --import /root/key.pub
TRUSTVAR=`gpg --fingerprint root | grep Key|cut -d= -f2|sed 's/ //g'`
TRUST_VALUE=':5:'
echo $TRUSTVAR$TRUST_VALUE >> /tmp/trust
gpg --import-ownertrust /tmp/trust

