#!/bin/bash -eux

/usr/bin/coreos-cloudinit --from-file=/var/lib/coreos-user_data

docker pull indiepaas/haproxy
docker pull indiepaas/confd
docker pull indiepaas/duplicity
docker pull ibuildthecloud/systemd-docker

# Create Directory structure
mkdir -p /data/domains
mkdir -p /data/runtime/haproxy/approved-certs
git clone https://github.com/indiepaas/IndiePaaS.git /data/indiehosters

# Install unit-files
cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

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

curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose
chmod +x /opt/bin/docker-compose
update_engine_client -update
