#!/bin/bash -eux

ROOT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/..

$ROOT_DIR/scripts/destroy_vultr.sh backup.test
ssh-keygen -f ~/.ssh/known_hosts -R backup.test
$ROOT_DIR/scripts/destroy_vultr.sh server.test
ssh-keygen -f ~/.ssh/known_hosts -R server.test

applications=( `cat $ROOT_DIR/SUPPORTED_APPLICATIONS` )

for application in "${applications[@]}"
do
  sudo sed -i "/$application.test/ d" /etc/hosts
done

