#!/bin/bash -eux

LABEL=$1
SUBID=`cat /etc/hosts | grep $LABEL | cut -d# -f2`
sudo sed -i "/$LABEL/ d" /etc/hosts
curl -d SUBID=$SUBID https://api.vultr.com/v1/server/destroy\?api_key\=$VULTR_API_KEY

