#!/bin/bash -eux

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

systemctl list-units | grep -c failed | grep 0

applications=( `cat $ROOT_DIR/SUPPORTED_APPLICATIONS` )

for application in "${applications[@]}"
do
  curl -Lk $application.test
  /data/indiehosters/tests/clean.sh $application
done
