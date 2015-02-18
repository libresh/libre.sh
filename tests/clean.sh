#!/bin/bash -eux
source /etc/environment
image=$1

systemctl stop web@$image.test

sleep 20

systemctl list-units | grep -c "$image\.test" | grep 0

rm -rf /data/runtime/domains/$image.test
rm -rf /data/domains/$image.test

ssh $BACKUP_DESTINATION "rm -rf $image.test"

