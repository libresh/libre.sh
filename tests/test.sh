#!/bin/bash -eux

image=$1

# prepare data
/data/indiehosters/scripts/provision.sh -e test@test.org -a $image -u $image.test -f /data/indiehosters/tests/unsecure-certs/indiehosters.dev.pem

if [ "$image" == "static" ]; then
  systemctl start $image@$image.test
  systemctl enable $image@$image.test
  sleep 30
else
  systemctl start lamp@$image.test
  systemctl enable lamp@$image.test
  sleep 60
fi

systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
curl -Lk $image.test

