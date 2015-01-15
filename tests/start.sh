#!/bin/bash -eux

applications=( static wordpress known )

for application in "${applications[@]}"
do
  /data/indiehosters/tests/test.sh $application
done
