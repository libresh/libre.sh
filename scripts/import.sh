#!/bin/bash -eux

if [ -d /data/import/$DOMAIN ]; then
  cp -r /data/import/$DOMAIN/* /data/domains/$DOMAIN;
  rm -rf /data/import/$DOMAIN;
fi
