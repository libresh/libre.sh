#!/bin/bash -eux

image=$1
if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  systemctl stop lamp@$image.test
  sleep 15
else
  systemctl stop $image@$image.test
fi

systemctl list-units | grep -c "$image\.test" | grep 0
rm -rf /data/import/$image.test
rm -rf /data/runtime/domains/$image.test
rm -rf /data/domains/$image.test
systemctl stop *@$image.test.timer
systemctl stop *@$image.test
systemctl reset-failed
if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  systemctl disable lamp@$image.test
else
  systemctl disable $image@$image.test
fi
systemctl list-units | grep -c "$image\.test" | grep 0
