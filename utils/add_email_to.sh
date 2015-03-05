#!/bin/bash -eux

DOMAIN=$1
PASSWORD=`echo $RANDOM  ${date} | md5sum | base64 | cut -c-10`
MYSQL_PASS=`cat /data/domains/mail/mysql/.env | cut -d= -f2`

/usr/bin/docker run \
  --rm \
  --name add_email_support_to_$DOMAIN \
  --link mysql-mail:db \
  pierreozoux/mysql \
    mysql \
      -uadmin \
      -p$MYSQL_PASS \
      -h db servermail <<EOF
INSERT INTO `servermail`.`virtual_domains` (`name`) VALUES ($DOMAIN);
INSERT INTO `servermail`.`virtual_users`
  (`domain_id`, `password` , `email`)
  VALUES(
  SELECT id FROM `servermail`.`virtual_domains` WHERE `name`=$DOMAIN,
  ENCRYPT('firstpassword', CONCAT('$6$', SUBSTRING(SHA(RAND()), -16))), 'contact@$DOMAIN');
EOF

#INSERT INTO `servermail`.`virtual_aliases`
#  (`domain_id`, `source`, `destination`)
#  VALUES
#  ('1', 'alias@example.com', 'email1@example.com');

