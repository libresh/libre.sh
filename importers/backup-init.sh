#!/bin/bash -eux

echo initializing backups for $USER
mkdir -p /data/per-user/$USER/backup/mysql
mkdir -p /data/per-user/$USER/backup/www
git config --global user.email "backups@`hostname`"
git config --global user.name "`hostname` hourly backups"
git config --global push.default simple

cd /data/per-user/$USER/backup/
git init
echo "backups of $USER at IndieHosters server `hostname`" > README.md
git add README.md
git commit -m"initial commit"

if [ -e /data/per-user/$USER/backup/BACKUPDEST ]; then
  cd /data/per-user/$USER/backup/
  git remote add destination `cat /data/per-user/$USER/backup/BACKUPDEST`
  git push -u destination master
fi
