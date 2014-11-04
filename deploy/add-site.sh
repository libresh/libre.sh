#!/bin/sh
if [ $# -ge 5 ]; then
  SERVER=$1
  DOMAIN=$2
  PEMFILE=$3
  IMAGE=$4
  GITREPO=$5
else
  echo "Usage: sh ./deploy/add-site.sh server domain pemfile image gitrepo [user]"
  exit 1
fi
if [ $# -ge 6 ]; then
  USER=$6
else
  USER="core"
fi
echo "Adding $DOMAIN to $SERVER, running $IMAGE behind $PEMFILE and pulling from $GITREPO"
echo "Remote user is $USER"

ssh $USER@$SERVER sudo mkdir -p /data/domains/$DOMAIN/$IMAGE/data
scp $PEMFILE $USER@$SERVER:/data/runtime/haproxy/approved-certs/$DOMAIN.pem
ssh $USER@$SERVER sudo sh /data/indiehosters/scripts/activate-user.sh $DOMAIN $IMAGE $GITREPO
