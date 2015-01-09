#!/bin/bash -eux

systemctl list-units | grep -c failed | grep 0

applications=( static static-git wordpress known)

for application in "${applications[@]}"
do
  /data/indiehosters/tests/test-image.sh $application
  /data/indiehosters/tests/deep-clean.sh $application
done
