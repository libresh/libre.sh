#!/bin/sh
if [ $# -ge 4 ]; then
  SERVER=$1
  DOMAIN=$2
  PEMFILE=$3
  GITREPO=$4
else
  echo "Usage: sh ./deploy/add-site.sh server domain pemfile gitrepo [user]"
  exit 1
fi
if [ $# -ge 5 ]; then
  USER=$5
else
  USER="core"
fi
echo "Adding $DOMAIN to $SERVER with cert from $PEMFILE"
echo "Remote user is $USER"

ssh $USER@$SERVER sudo mkdir -p /data/per-user/$DOMAIN/nginx/data
scp $PEMFILE $USER@$SERVER:/data/server-wide/haproxy/approved-certs/$DOMAIN.pem
ssh $USER@$SERVER sudo sh /data/indiehosters/scripts/activate-user.sh $DOMAIN nginx $GITREPO
