#!/bin/bash -eux

mkdir -p /data/per-user/$1/nginx/data
touch /data/per-user/$1/nginx/.env
if [ -e /data/per-user/$1/nginx/data/www-content ]; then
  cd /data/per-user/$1/nginx/data/www-content; git pull --rebase
else
  git clone $3 /data/per-user/$1/nginx/data/www-content
fi

# Start service for new site (and create the user)
systemctl enable $2@$1.service
systemctl start  $2@$1.service
