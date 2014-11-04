#!/bin/bash -eux

if [ ! -e "/data/per-user/$DOMAIN/nginx/data/www-content/index.html" ]; then
  if [ -e "/data/per-user/$DOMAIN/nginx/data/GITURL" ]; then
    git clone `cat /data/per-user/$DOMAIN/nginx/data/GITURL` /data/per-user/$DOMAIN/nginx/data/www-content
    cd /data/per-user/$DOMAIN/nginx/data/www-content && git checkout master
  else
    mkdir -p /data/per-user/$DOMAIN/nginx/data/www-content
    echo Hello $DOMAIN > /data/per-user/$DOMAIN/nginx/data/www-content/index.html
  fi
fi
