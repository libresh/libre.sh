#!/bin/bash -eux

/usr/bin/coreos-cloudinit --from-file=/var/lib/coreos-user_data

docker pull indiepaas/rsyslog
docker pull indiepaas/haproxy
docker pull indiepaas/confd
docker pull indiepaas/postfix
docker pull indiepaas/dovecot
docker pull indiepaas/nginx
docker pull indiepaas/mysql
docker pull indiepaas/wordpress
docker pull indiepaas/known
docker pull indiepaas/piwik
docker pull indiepaas/owncloud
docker pull indiepaas/duplicity
docker pull ibuildthecloud/systemd-docker

# Create Directory structure
mkdir -p /data/domains
mkdir -p /data/runtime/haproxy/approved-certs
git clone https://github.com/indiepaas/IndiePaaS.git /data/indiehosters

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

# Configure and start HAproxy
cp /data/indiehosters/tests/unsecure-certs/indiehosters.dev.pem /data/runtime/haproxy/approved-certs/default.pem

systemctl enable rsyslog
systemctl start  rsyslog
systemctl enable confd
systemctl start  confd
systemctl enable haproxy.path
systemctl start  haproxy.path

source /etc/environment
# Put the backup server in known_hosts files using RSA algo
# https://github.com/paramiko/paramiko/issues/243
ssh -o "StrictHostKeyChecking no" -o "BatchMode yes" -o "HostKeyAlgorithms=ssh-rsa" $BACKUP_DESTINATION exit

# Import backup encryption key
gpg --import /root/key.pub
TRUSTVAR=`gpg --fingerprint root | grep Key|cut -d= -f2|sed 's/ //g'`
TRUST_VALUE=':6:'
echo $TRUSTVAR$TRUST_VALUE | gpg --import-ownertrust

docker run --rm -v /opt/bin:/target jpetazzo/nsenter

