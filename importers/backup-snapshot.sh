#!/bin/bash -eux

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

if [ -e /data/per-user/$USER/wordpress ]; then
  echo backing up www from wordpress for $USER
  mkdir -p /data/per-user/$USER/backup/www/wordpress/
  cp /data/per-user/$USER/wordpress/.env /data/per-user/$USER/backup/www/wordpress/.env
  rsync -r /data/per-user/$USER/wordpress/data/wp-content /data/per-user/$USER/backup/www/wordpress/wp-content
fi

if [ -e /data/per-user/$USER/nginx ]; then
  echo backing up www from nginx for $USER
  mkdir -p /data/per-user/$USER/backup/www/nginx/
  if [ -e /data/per-user/$USER/nginx/data/GITURL ]; then
    cp /data/per-user/$USER/nginx/data/GITURL /data/per-user/$USER/backup/www/nginx/GITURL
  else
    rsync -r /data/per-user/$USER/nginx/data/www-content /data/per-user/$USER/backup/www/nginx/www-content
  fi
fi

echo copying TLS cert
mkdir -p /data/per-user/$USER/backup/TLS/
cp /data/server-wide/haproxy/approved-certs/$USER.pem /data/per-user/$USER/backup/TLS/$USER.pem

echo committing everything
cd /data/per-user/$USER/backup/
pwd
git add *
git status
git commit -m"backup $USER @ `hostname` - `date`"
if [ -e /data/per-user/$USER/backup/BACKUPDEST ]; then
  git pull --rebase
  git push
fi
