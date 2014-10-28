#!/bin/bash -eux

if [ $# -ge 2 ]; then
  DOMAIN=$1
  IMAGE=$2
else
  echo "Usage: sh /data/indiehosters/scripts/activate-user domain image [gitrepo]"
  exit 1
fi
mkdir -p /data/per-user/$DOMAIN/nginx/data
if [ $# -ge 3 ]; then
  GITREPO=$3
  echo $GITREPO > /data/per-user/$DOMAIN/nginx/data/git-url.txt
fi

# Start service for new site (and create the user). This will also enable the git puller.
systemctl enable $IMAGE@$DOMAIN.service
systemctl start  $IMAGE@$DOMAIN.service
