#!/bin/bash -eux

image=$1

# prepare data
/data/indiehosters/scripts/provision.sh -s -e test@test.org -a $image -u $image.test -f /data/indiehosters/tests/unsecure-certs/indiehosters.dev.pem

if [ "$image" == "static" ]; then
  sleep 30
else
  sleep 70
fi

systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
curl -Lk $image.test

