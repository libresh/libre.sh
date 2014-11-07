#!/bin/bash -eux

cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload

image=$1

# prepare data
mkdir -p /data/import/$image.test/TLS
cp /data/indiehosters/scripts/unsecure-certs/example.dev.pem /data/import/$image.test/TLS/$image.test.pem
if [ "$image" == "static-git" ]; then
  mkdir -p /data/import/$image.test/static-git
  echo "https://github.com/indiehosters/website.git" > /data/import/$image.test/static-git/GITURL
fi

# start image from import
systemctl start $image@$image.test

if [ "$image" == "wordpress" ]; then
  sleep 40
else
  sleep 10
fi

# tests
systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
ip=`docker inspect --format {{.NetworkSettings.IPAddress}} $image-$image.test`
curl -L $ip

# start image from backup
/data/indiehosters/tests/runtime-clean-image.sh $image
if [ "$image" == "wordpress" ]; then
  echo should fail until implementation of mysql backup importer
fi
systemctl start $image@$image.test
sleep 10

# tests
systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
ip=`docker inspect --format {{.NetworkSettings.IPAddress}} $image-$image.test`
curl $ip
