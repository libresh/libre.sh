#!/bin/bash -eux

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

applications=( `cat $ROOT_DIR/SUPPORTED_APPLICATIONS` )

for application in "${applications[@]}"
do
  /data/indiehosters/tests/test.sh $application
done
