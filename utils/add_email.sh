#!/bin/bash -ex

EMAIL=$1
PASSWORD=`echo $RANDOM date | md5sum | base64 | cut -c-10`
MYSQL_PASS=`cat /data/domains/mail/mysql/.env | cut -d= -f2`

DOMAIN=$(echo ${EMAIL} | cut -f2 -d@)

/usr/bin/docker run \
  --rm \
  --name add_email_support_to_$DOMAIN \
  --link mysql-mail:db \
  indiepaas/mysql \
    mysql \
      -uadmin \
      -p$MYSQL_PASS \
      -h db \
        -e "INSERT INTO servermail.virtual_users (domain_id, password , email) \
          VALUES( \
            (SELECT id FROM servermail.virtual_domains WHERE name='$DOMAIN'), \
            ENCRYPT('$PASSWORD', CONCAT('\$6\$', SUBSTRING(SHA(RAND()), -16))), \
            '$EMAIL');"

echo "Email added with success"
echo "Pass: $PASSWORD"


