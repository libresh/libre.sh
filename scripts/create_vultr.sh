#!/bin/bash

LABEL=$1

SSHKEYID=`curl -s https://api.vultr.com/v1/sshkey/list\?api_key\=$VULTR_API_KEY | cut -d\" -f2`

SUBID=`curl -s -d "DCID=24&VPSPLANID=29&OSID=179&label=$LABEL&SSHKEYID=$SSHKEYID" https://api.vultr.com/v1/server/create\?api_key\=$VULTR_API_KEY | cut -d\" -f4`

IP=0

while [ "$IP" == "0" ]
do
  echo "waiting to get an IP..."
  sleep 5
  IP=`curl -s https://api.vultr.com/v1/server/list_ipv4\?api_key\=$VULTR_API_KEY\&SUBID\=$SUBID | cut -d\" -f6`
done

sudo -- sh -c "echo $IP $LABEL \#$SUBID >> /etc/hosts"

while :
do
  ssh root@$LABEL exit
  if [ $? == 0 ];
  then
    break
  else
    echo "waiting to be able to ssh..."
    sleep 5
  fi
done

