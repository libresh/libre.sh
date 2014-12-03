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

# tests
/data/indiehosters/tests/test-image.sh $image

# start image from backup
## make sure to backup first
systemctl start backup@$image.test
/data/indiehosters/tests/clean-image.sh $image
systemctl enable $image@$image.test
systemctl start $image@$image.test

# tests
/data/indiehosters/tests/test-image.sh $image
