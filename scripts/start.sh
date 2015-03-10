#!/bin/bash -eux

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

# Create backup for tests

$ROOT_DIR/scripts/create_vultr.sh backup.test

scp $ROOT_DIR/configs/backup.config root@backup.test:/var/lib/coreos-install/user_data
ssh root@backup.test /usr/bin/coreos-cloudinit --from-file=/var/lib/coreos-install/user_data
BACKUP_IP=`cat /etc/hosts | grep backup.test | cut -d" " -f1`

# Create server for tests

$ROOT_DIR/scripts/create_vultr.sh server.test
cat $ROOT_DIR/configs/server.config | sed s/##BACKUP_IP##/$BACKUP_IP/g > /tmp/server.config
scp /tmp/server.config root@server.test:/var/lib/coreos-install/user_data
scp $ROOT_DIR/scripts/install.sh root@server.test:/tmp/install.sh
ssh root@server.test /tmp/install.sh
IP=`cat /etc/hosts | grep server.test | cut -d" " -f1`

# Adds ip to /etc/hosts file

echo "We'll now modify your /etc/hosts to add the test application name"
applications=( `cat $ROOT_DIR/SUPPORTED_APPLICATIONS` )
for application in "${applications[@]}"
do
  echo Writing $LABEL to /etc/hosts file, needs your root password:
  sudo -- sh -c "echo $IP $application.test  >> /etc/hosts"
done

