#!/bin/bash -eux

applications=( static static-git wordpress known)

for application in "${applications[@]}"
do
  /data/indiehosters/tests/image.sh $application
done
