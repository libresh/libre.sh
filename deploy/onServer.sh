#!/bin/sh

echo Starting etcd:
/usr/bin/coreos-cloudinit --from-file=/var/lib/coreos-install/user_data

echo Cloning the infrastructure repo into /data/infrastructure:
mkdir /data
cd /data
git clone https://github.com/indiehosters/infrastructure.git
cd infrastructure

echo Checking out $1 branch of the IndieHosters infrastructure:
git checkout $1
git pull

echo Running the server setup script:
sh scripts/setup.sh $2
