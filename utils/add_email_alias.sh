#!/bin/bash -ex

DOMAIN=$1
SOURCE=$2
DESTINATION=$3
MYSQL_PASS=`cat /data/domains/mail/mysql/.env | cut -d= -f2`

/usr/bin/docker run \
  --rm \
  --name add_email_support_to_$DOMAIN \
  --link mysql-mail:db \
  indiepaas/mysql \
    mysql \
      -uadmin \
      -p$MYSQL_PASS \
      -h db \
        -e "INSERT INTO servermail.virtual_aliases (domain_id, source , destination) \
          VALUES( \
            (SELECT id FROM servermail.virtual_domains WHERE name='$DOMAIN'), \
            '$SOURCE',
            '$DESTINATION');"

