#!/bin/bash -eux

cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload

image=$1

# prepare data
mkdir -p /data/import/$image.test/TLS
cp /data/indiehosters/scripts/unsecure-certs/example.dev.pem /data/import/$image.test/TLS/$image.test.pem
echo "APPLICATION=$image" > /data/import/$image.test/.env
if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  echo "VOLUME=$(cat /data/indiehosters/dockerfiles/services/$image/VOLUME)" >> /data/import/$image.test/.env
  echo "EMAIL=test@test.org" >> /data/import/$image.test/.env
fi

# start image from import
if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  systemctl start lamp@$image.test
else
  systemctl start $image@$image.test
fi

# tests
/data/indiehosters/tests/test-image.sh $image

# start image from backup
## make sure to backup first
systemctl start backup@$image.test
/data/indiehosters/tests/clean-image.sh $image
if [ "$image" == "wordpress" ] || [ "$image" == "known" ]; then
  systemctl enable lamp@$image.test
  systemctl start lamp@$image.test
else
  systemctl enable $image@$image.test
  systemctl start $image@$image.test
fi

# tests
/data/indiehosters/tests/test-image.sh $image
