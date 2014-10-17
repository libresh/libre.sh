#!/bin/sh
if [ $# -ge 1 ]; then
  SERVER=$1
else
  echo "Usage: sh ./deploy/deploy.sh server [branch [user]]"
  exit 1
fi
if [ $# -ge 2 ]; then
  BRANCH=$2
else
  BRANCH="master"
fi
if [ $# -ge 3 ]; then
  USER=$3
else
  USER="core"
fi
if [ -e ../orchestration/per-server/$SERVER/default-site ]; then
  DEFAULTSITE=`cat ../orchestration/per-server/$SERVER/default-site`
else
  DEFAULTSITE=$SERVER
fi
echo "Infrastructure branch is $BRANCH"
echo "Remote user is $USER"
echo "Default site is $DEFAULTSITE"

chmod -R go-w ../orchestration/deploy-keys
if [ -f ../orchestration/deploy-keys/authorized_keys ]; then
  scp -r ../orchestration/deploy-keys $USER@$SERVER:.ssh
fi
scp ./deploy/onServer.sh $USER@$SERVER:
ssh $USER@$SERVER sudo mkdir -p /var/lib/coreos-install/
scp ../infrastructure/cloud-config $USER@$SERVER:/var/lib/coreos-install/user_data
ssh $USER@$SERVER sudo sh ./onServer.sh $BRANCH $DEFAULTSITE
cd ../orchestration/per-server/$SERVER/sites/
for i in * ; do
  echo "setting up site $i as `cat $i` on $SERVER";
  ssh $USER@$SERVER sudo mkdir -p /data/per-user/$i/
  scp ../../../TLS/approved-certs/$i.pem $USER@$SERVER:/data/server-wide/haproxy/approved-certs/$i.pem
  rsync -r ../../../../user-data/live/$SERVER/$i/ $USER@$SERVER:/data/per-user/$i/
  ssh $USER@$SERVER sudo sh /data/infrastructure/scripts/activate-user.sh $i `cat $i`
done

# Restart the default site now that its data has been rsync'ed in place:
ssh $USER@$SERVER sudo systemctl restart nginx\@$DEFAULTSITE
