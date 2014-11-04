#!/bin/sh
if [ $# -ge 2 ]; then
  USER=$1
  BACKUPDEST=$2
else
  echo "Usage: sh ./scripts/backups-init.sh domain gitrepo"
  exit 1
fi
echo "Adding backup job for $USER to $BACKUPDEST"

echo "First, trying to clone latest master from $BACKUPDEST"
git clone $BACKUPDEST /data/per-user/$USER/backup

sudo mkdir -p /data/per-user/$USER/backup
sudo echo "$BACKUPDEST" > /data/per-user/$USER/backup/BACKUPDEST

echo initializing backups for $USER
mkdir -p /data/per-user/$USER/backup/mysql
mkdir -p /data/per-user/$USER/backup/www
mkdir -p /data/per-user/$USER/backup/TLS
cd /data/per-user/$USER/backup/
git config --local user.email "backups@`hostname`"
git config --local user.name "`hostname` hourly backups"
git config --local push.default simple

if [ -e /data/per-user/$USER/backup/.git ]; then
  git init
fi
echo "backups of $USER at IndieHosters server `hostname`" > README.md
git add README.md
git commit -m"initial commit"

echo "Pushing initial commit to $BACKUPDEST master branch"
cd /data/per-user/$USER/backup/
git remote add destination $BACKUPDEST
git push -u destination master
