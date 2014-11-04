#!/bin/bash -eux

if [ ! -d "/data/per-user/$DOMAIN/mysql/data" ]; then
  mkdir -p /data/per-user/$DOMAIN/mysql/data
  echo MYSQL_PASS=`echo $RANDOM  ${date} | md5sum | base64 | cut -c-10` > /data/per-user/$DOMAIN/mysql/.env
fi
