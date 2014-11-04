#!/bin/bash -eux

if [ -e /data/domains/$DOMAIN/mysql ]; then
  echo backing up mysql databases for $DOMAIN
  mkdir -p /data/domains/$DOMAIN/backup/mysql/
  cp /data/domains/$DOMAIN/mysql/.env /data/domains/$DOMAIN/backup/mysql/.env
  /usr/bin/docker run --link mysql-$DOMAIN:db\
     --env-file /data/domains/$DOMAIN/mysql/.env \
     indiehosters/mysql mysqldump --all-databases --events -u admin \
     -p$(cat /data/domains/$DOMAIN/mysql/.env | cut -d'=' -f2) \
     -h db > /data/domains/$DOMAIN/backup/mysql/dump.sql
fi

if [ -e /data/domains/$DOMAIN/wordpress ]; then
  echo backing up www from wordpress for $DOMAIN
  mkdir -p /data/domains/$DOMAIN/backup/www/
  rsync -r /data/domains/$DOMAIN/wordpress /data/domains/$DOMAIN/backup/www/wordpress
fi

if [ -e /data/domains/$DOMAIN/nginx ]; then
  echo backing up www from nginx for $DOMAIN
  mkdir -p /data/domains/$DOMAIN/backup/www/nginx/
  if [ -e /data/domains/$DOMAIN/nginx/data/GITURL ]; then
    cp /data/domains/$DOMAIN/nginx/data/GITURL /data/domains/$DOMAIN/backup/www/nginx/GITURL
  else
    rsync -r /data/domains/$DOMAIN/nginx/data/www-content /data/domains/$DOMAIN/backup/www/nginx/www-content
  fi
fi

echo copying TLS cert
mkdir -p /data/domains/$DOMAIN/backup/TLS/
cp /data/runtime/haproxy/approved-certs/$DOMAIN.pem /data/domains/$DOMAIN/backup/TLS/$DOMAIN.pem

echo committing everything
cd /data/domains/$DOMAIN/backup/
pwd
git add *
git status

git config --local user.email "backups@`hostname`"
git config --local user.name "`hostname` hourly backups"
git config --local push.default simple

git commit -m"backup $DOMAIN @ `hostname` - `date`"
if [ -e /data/domains/$DOMAIN/backup/BACKUPDEST ]; then
  git pull --rebase
  git push
fi
