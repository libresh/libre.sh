#!/bin/sh
if [ $# -ge 3 ]; then
  SERVER=$1
  DOMAIN=$2
  PEMFILE=$3
else
  echo "Usage: sh ./deploy/add-placeholder-site.sh server domain pemfile [user]"
  exit 1
fi
if [ $# -ge 4 ]; then
  USER=$4
else
  USER="core"
fi
echo "Adding $DOMAIN to $SERVER with cert from $PEMFILE"
echo "Remote user is $USER"

ssh $USER@$SERVER sudo mkdir -p /data/domains/$DOMAIN/static
scp $PEMFILE $USER@$SERVER:/data/runtime/haproxy/approved-certs/$DOMAIN.pem
ssh $USER@$SERVER sudo sh /data/indiehosters/scripts/activate-user.sh $DOMAIN static
