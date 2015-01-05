#!/bin/sh
if [ $# -ge 2 ]; then
  SERVER=$1
  BACKUP_DEST=$2
else
  echo "Usage: sh ./deploy/deploy.sh server backup_dest [branch [user]]]"
  exit 1
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

echo "Server to deploy is $SERVER"
echo "Backups will live under $BACKUP_DEST"
echo "IndieHosters repo branch is $BRANCH"
echo "Remote user is $USER"

scp ./deploy/onServer.sh $USER@$SERVER:

ssh $USER@$SERVER sudo mkdir -p /var/lib/coreos-install/
scp cloud-config $USER@$SERVER:/var/lib/coreos-install/user_data
ssh $USER@$SERVER sudo sh ./onServer.sh $BRANCH $SERVER

# overrides BACKUP_DESTINATION from cloud-config
echo $BACKUP_DEST > ./deploy/tmp.txt
scp ./deploy/tmp.txt $USER@$SERVER:/data/BACKUP_DESTINATION
rm ./deploy/tmp.txt
