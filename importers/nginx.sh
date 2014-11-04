#!/bin/bash -eux

if [ ! -e "/data/domains/$DOMAIN/nginx/data/www-content/index.html" ]; then
  if [ -e "/data/domains/$DOMAIN/nginx/data/GITURL" ]; then
    git clone `cat /data/domains/$DOMAIN/nginx/data/GITURL` /data/domains/$DOMAIN/nginx/data/www-content
    cd /data/domains/$DOMAIN/nginx/data/www-content && git checkout master
  else
    mkdir -p /data/domains/$DOMAIN/nginx/data/www-content
    echo Hello $DOMAIN > /data/domains/$DOMAIN/nginx/data/www-content/index.html
  fi
fi
