#!/bin/bash -eux
source /etc/environment

image=$1
systemctl stop web@$image.test
if [ "$image" == "static" ]; then
  systemctl disable $image@$image.test
else
  systemctl disable lamp@$image.test
fi

systemctl stop *@$image.test.timer
systemctl stop *@$image.test
systemctl reset-failed
rm -rf /data/runtime/domains/$image.test
rm -rf /data/domains/$image.test
ssh $BACKUP_DESTINATION "rm -rf $image.test"
systemctl list-units | grep "$image\.test"

