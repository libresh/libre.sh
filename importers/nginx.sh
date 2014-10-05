#!/bin/bash

if [ ! -d "/data/per-user/$USER/nginx/data" ]; then
  mkdir -p /data/per-user/$USER/nginx/data/www-content
  echo Hello $USER > /data/per-user/$USER/nginx/data/www-content/index.html
  touch /data/per-user/$USER/nginx/.env
fi
