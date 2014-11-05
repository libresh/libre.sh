#!/bin/bash -eux

BACKUP_DESTINATION=`cat /data/BACKUP_DESTINATION`

echo "Intitializing backups with $BACKUP_DESTINATION"
if [ ! -d /data/domains/$DOMAIN/.git ]; then
  if [ `ssh $BACKUP_DESTINATION "test -d $DOMAIN"; echo $?` -eq 0 ]; then # git repo exists on the backup server
    git clone $BACKUP_DESTINATION:$DOMAIN /data/domains/$DOMAIN
    cd /data/domains/$DOMAIN
  else
    ssh $BACKUP_DESTINATION " \
      mkdir -p $DOMAIN; \
      cd $DOMAIN; \
      git init --bare;"
    if [ ! -d /data/domains/$DOMAIN ]; then
      mkdir /data/domains/$DOMAIN
    fi
    cd /data/domains/$DOMAIN
    git init
    git remote add origin $BACKUP_DESTINATION:$DOMAIN
  fi
  git config --local user.email "backups@`hostname`"
  git config --local user.name "`hostname` hourly backups"
fi
