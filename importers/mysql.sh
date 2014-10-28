#!/bin/bash

if [ ! -d "/data/per-user/$USER/mysql/data" ]; then
  mkdir -p /data/per-user/$USER/mysql/data
  echo MYSQL_PASS=`echo $RANDOM  ${date} | md5sum | base64 | cut -c-10` > /data/per-user/$USER/mysql/.env
fi
