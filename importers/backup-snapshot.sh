#!/bin/bash -eux

if [ -e /data/per-user/$DOMAIN/mysql ]; then
  echo backing up mysql databases for $DOMAIN
  mkdir -p /data/per-user/$DOMAIN/backup/mysql/
  cp /data/per-user/$DOMAIN/mysql/.env /data/per-user/$DOMAIN/backup/mysql/.env
  /usr/bin/docker run --link mysql-$DOMAIN:db\
     --env-file /data/per-user/$DOMAIN/mysql/.env \
     indiehosters/mysql mysqldump --all-databases --events -u admin \
     -p$(cat /data/per-user/$DOMAIN/mysql/.env | cut -d'=' -f2) \
     -h db > /data/per-user/$DOMAIN/backup/mysql/dump.sql
fi

if [ -e /data/per-user/$DOMAIN/wordpress ]; then
  echo backing up www from wordpress for $DOMAIN
  mkdir -p /data/per-user/$DOMAIN/backup/www/
  rsync -r /data/per-user/$DOMAIN/wordpress /data/per-user/$DOMAIN/backup/www/wordpress
fi

if [ -e /data/per-user/$DOMAIN/nginx ]; then
  echo backing up www from nginx for $DOMAIN
  mkdir -p /data/per-user/$DOMAIN/backup/www/nginx/
  if [ -e /data/per-user/$DOMAIN/nginx/data/GITURL ]; then
    cp /data/per-user/$DOMAIN/nginx/data/GITURL /data/per-user/$DOMAIN/backup/www/nginx/GITURL
  else
    rsync -r /data/per-user/$DOMAIN/nginx/data/www-content /data/per-user/$DOMAIN/backup/www/nginx/www-content
  fi
fi

echo copying TLS cert
mkdir -p /data/per-user/$DOMAIN/backup/TLS/
cp /data/server-wide/haproxy/approved-certs/$DOMAIN.pem /data/per-user/$DOMAIN/backup/TLS/$DOMAIN.pem

echo committing everything
cd /data/per-user/$DOMAIN/backup/
pwd
git add *
git status

git config --local user.email "backups@`hostname`"
git config --local user.name "`hostname` hourly backups"
git config --local push.default simple

git commit -m"backup $DOMAIN @ `hostname` - `date`"
if [ -e /data/per-user/$DOMAIN/backup/BACKUPDEST ]; then
  git pull --rebase
  git push
fi
