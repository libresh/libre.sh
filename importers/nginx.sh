#!/bin/bash

if [ ! -e "/data/per-user/$USER/nginx/data/www-content/index.html" ]; then
  if [ -e "/data/per-user/$USER/nginx/data/git-url.txt" ]; then
    git clone `cat /data/per-user/$USER/nginx/data/git-url.txt` /data/per-user/$USER/nginx/data/www-content
  else
    mkdir -p /data/per-user/$USER/nginx/data/www-content
    echo Hello $USER > /data/per-user/$USER/nginx/data/www-content/index.html
  fi
fi
