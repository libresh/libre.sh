#!/bin/bash

if [ -e /data/per-user/$USER/mysql ]; then
  echo backing up mysql databases for $USER
  mkdir -p /data/per-user/$USER/backup/mysql/
  cp /data/per-user/$USER/mysql/.env /data/per-user/$USER/backup/mysql/.env
  /usr/bin/docker run --link mysql-$USER:db\
     --env-file /data/per-user/$USER/mysql/.env \
     indiehosters/mysql mysqldump --all-databases --events -u admin \
     -p$(cat /data/per-user/$USER/mysql/.env | cut -d'=' -f2) \
     -h db > /data/per-user/$USER/backup/mysql/dump.sql
fi

if [ -e /data/per-user/$USER/wordpress-subdir ]; then
  echo backing up www from wordpress-subdir for $USER
  mkdir -p /data/per-user/$USER/backup/www/wordpress-subdir/
  cp /data/per-user/$USER/wordpress-subdir/.env /data/per-user/$USER/backup/www/wordpress-subdir/.env
  rsync -r /data/per-user/$USER/wordpress-subdir/data/wp-content /data/per-user/$USER/backup/www/wordpress-subdir/wp-content
  if [ -e /data/per-user/$USER/wordpress-subdir/data/GITURL ]; then
    cp /data/per-user/$USER/wordpress-subdir/data/GITURL /data/per-user/$USER/backup/www/wordpress-subdir/GITURL
  fi
fi

cd /data/per-user/$USER/backup/
git add *
git commit -m"backup $USER @ `hostname` - `date`"
if [ -e /data/per-user/$USER/backup/BACKUPDEST ]; then
  git pull --rebase
  git push
fi
