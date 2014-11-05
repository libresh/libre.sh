#!/bin/bash -eux

BACKUP_DESTINATION=`cat /data/BACKUP_DESTINATION`

echo "Intitializing backups with $BACKUP_DESTINATION"
if [ ! -d /data/domains/$DOMAIN ]; then
  ssh $BACKUP_DESTINATION " \
    if [ ! -d $DOMAIN ]; then \
      mkdir -p $DOMAIN; \
      cd $DOMAIN; \
      git init --bare; \
    else
      echo \"Git folder already present\"
    fi"
  git clone $BACKUP_DESTINATION:$DOMAIN /data/domains/$DOMAIN
  cd /data/domains/$DOMAIN
  git config --local user.email "backups@`hostname`"
  git config --local user.name "`hostname` hourly backups"
  git config --local push.default simple
fi
