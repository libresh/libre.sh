#!/bin/bash -eux

image=$1

if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  sleep 70
else
  sleep 10
fi

systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
ip=`docker inspect --format {{.NetworkSettings.IPAddress}} $image-$image.test`
curl -L $ip
