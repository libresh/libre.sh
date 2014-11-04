#!/bin/bash -eux

if [ ! -d "/data/domains/$DOMAIN/wordpress/data" ]; then
  cd /data/domains/$DOMAIN/
  tar xvzf /data/indiehosters/blueprints/wordpress.tgz
fi

cat /data/domains/$DOMAIN/mysql/.env | sed s/MYSQL_PASS/DB_PASS/ > /data/domains/$DOMAIN/wordpress/.env
