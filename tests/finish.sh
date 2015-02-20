#!/bin/bash -eux

systemctl list-units | grep -c failed | grep 0

applications=( static wordpress known piwik owncloud )

for application in "${applications[@]}"
do
  curl -Lk $application.test
  /data/indiehosters/tests/clean.sh $application
done
