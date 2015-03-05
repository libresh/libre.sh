#!/bin/bash -ex

DOMAIN=$1
PASSWORD=`echo $RANDOM date | md5sum | base64 | cut -c-10`
MYSQL_PASS=`cat /data/domains/mail/mysql/.env | cut -d= -f2`

/usr/bin/docker run \
  --rm \
  --name add_email_support_to_$DOMAIN \
  --link mysql-mail:db \
  pierreozoux/mysql \
    mysql \
      -uadmin \
      -p$MYSQL_PASS \
      -h db \
        -e "INSERT INTO servermail.virtual_domains (name) VALUES ('$DOMAIN');" \
        -e "INSERT INTO servermail.virtual_users (domain_id, password , email) \
          VALUES( \
            (SELECT id FROM servermail.virtual_domains WHERE name='$DOMAIN'), \
            ENCRYPT('$PASSWORD', CONCAT('\$6\$', SUBSTRING(SHA(RAND()), -16))), \
            'contact@$DOMAIN');"

