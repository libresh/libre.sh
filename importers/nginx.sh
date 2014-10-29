#!/bin/bash

if [ ! -e "/data/per-user/$USER/nginx/data/www-content/index.html" ]; then
  if [ -e "/data/per-user/$USER/nginx/data/GITURL" ]; then
    git clone `cat /data/per-user/$USER/nginx/data/GITURL` /data/per-user/$USER/nginx/data/www-content
    cd /data/per-user/$USER/nginx/data/www-content && git checkout master
  else
    mkdir -p /data/per-user/$USER/nginx/data/www-content
    echo Hello $USER > /data/per-user/$USER/nginx/data/www-content/index.html
  fi
fi
