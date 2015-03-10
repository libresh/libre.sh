#!/bin/bash

function valid_ip()
{
  local  ip=$1
  local  stat=1
  if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
    OIFS=$IFS
    IFS='.'
    ip=($ip)
    IFS=$OIFS
    [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
      && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
    stat=$?
  fi
  return $stat
}

LABEL=$1
echo Label: $LABEL
echo API key: $VULTR_API_KEY

SSHKEYID=`curl -s https://api.vultr.com/v1/sshkey/list\?api_key\=$VULTR_API_KEY | cut -d\" -f2`
echo Got your ssh key ID $SSHKEYID:

SUBID=`curl -s -d "DCID=24&VPSPLANID=29&OSID=179&label=$LABEL&SSHKEYID=$SSHKEYID" https://api.vultr.com/v1/server/create\?api_key\=$VULTR_API_KEY | cut -d\" -f4`
echo Got your SUB ID $SUBID:

while :
do
  IP=`curl -s https://api.vultr.com/v1/server/list_ipv4\?api_key\=$VULTR_API_KEY\&SUBID\=$SUBID | cut -d\" -f6`
  if valid_ip $IP; then
    break
  else
    echo "waiting to get an IP..."
    sleep 5
  fi
done

echo Writing $LABEL to /etc/hosts file, needs your root password:
sudo -- sh -c "echo $IP $LABEL \#$SUBID >> /etc/hosts"

while :
do
  ssh -o "StrictHostKeyChecking no" -o "BatchMode yes" root@$LABEL exit
  if [ $? == 0 ];
  then
    break
  else
    echo "waiting to be able to ssh..."
    sleep 5
  fi
done

