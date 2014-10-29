#!/bin/bash

if [ ! -d "/data/per-user/$USER/wordpress/data" ]; then
  cd /data/per-user/$USER/
  tar xvzf /data/indiehosters/blueprints/wordpress.tgz
fi

cat /data/per-user/$USER/mysql/.env | sed s/MYSQL_PASS/DB_PASS/ > /data/per-user/$USER/wordpress/.env
