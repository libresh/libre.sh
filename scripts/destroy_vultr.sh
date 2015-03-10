#!/bin/bash -eux

LABEL=$1
SUBID=`cat /etc/hosts | grep $LABEL | cut -d# -f2`

echo Writing $LABEL to /etc/hosts file, needs your root password:
sudo sed -i "/$LABEL/ d" /etc/hosts

curl -d SUBID=$SUBID https://api.vultr.com/v1/server/destroy\?api_key\=$VULTR_API_KEY

