#!/bin/sh
if [ $# -ge 1 ]; then
  SERVER=$1
else
  echo "Usage: sh ./deploy/deploy.sh server [folder [branch [user]]]"
  exit 1
fi
if [ $# -ge 2 ]; then
  FOLDER=$2
else
  FOLDER="./data/"
fi
if [ $# -ge 3 ]; then
  BRANCH=$3
else
  BRANCH="master"
fi
if [ $# -ge 4 ]; then
  USER=$4
else
  USER="core"
fi
if [ -e ../orchestration/per-server/$SERVER/default-site ]; then
  DEFAULTSITE=`cat ../orchestration/per-server/$SERVER/default-site`
else
  DEFAULTSITE=$SERVER
fi
echo "Hoster data folder is $FOLDER"
echo "Infrastructure branch is $BRANCH"
echo "Remote user is $USER"
echo "Default site is $DEFAULTSITE"

scp -r $FOLDER $USER@$SERVER:/data
scp ./deploy/onServer.sh $USER@$SERVER:
ssh $USER@$SERVER sudo mkdir -p /var/lib/coreos-install/
scp cloud-config $USER@$SERVER:/var/lib/coreos-install/user_data
ssh $USER@$SERVER sudo sh ./onServer.sh $BRANCH $DEFAULTSITE
