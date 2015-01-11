#!/bin/bash -eux

applications=( static staticgit wordpress known)

for application in "${applications[@]}"
do
  /data/indiehosters/tests/image.sh $application
done
