#!/bin/bash -eux

systemctl list-units | grep -c failed | grep 0

applications=( static wordpress known )

for application in "${applications[@]}"
do
  /data/indiehosters/tests/clean.sh $application
done
