#!/bin/bash -eux

if [ ! -d "/data/per-user/$DOMAIN/wordpress/data" ]; then
  cd /data/per-user/$DOMAIN/
  tar xvzf /data/indiehosters/blueprints/wordpress.tgz
fi

cat /data/per-user/$DOMAIN/mysql/.env | sed s/MYSQL_PASS/DB_PASS/ > /data/per-user/$DOMAIN/wordpress/.env
