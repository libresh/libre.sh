#!/bin/bash -eux

mkdir -p /data/per-user/$1/$2/data
cd /data/per-user/$1/$2/data
if [ -e www-content ]; then
  cd www-content
  git pull
else
  git clone $3 www-content
fi

# Start service for new site (and create the user)
systemctl enable $2@$1.service
systemctl start  $2@$1.service
