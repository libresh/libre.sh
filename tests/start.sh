#!/bin/bash -eux

applications=( static wordpress known piwik owncloud )

for application in "${applications[@]}"
do
  /data/indiehosters/tests/test.sh $application
done
