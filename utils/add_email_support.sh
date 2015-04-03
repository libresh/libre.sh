#!/bin/bash -ex

DOMAIN=$1
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
        -e "INSERT INTO servermail.virtual_domains (name) VALUES ('$DOMAIN');"

mkdir -p /data/domains/mail/opendkim/keys/$DOMAIN

/usr/bin/docker run \
  --rm \
  --name opendkim-genkey \
  -v /data/domains/mail/opendkim:/etc/opendkim \
  indiepaas/postfix \
    /usr/bin/opendkim-genkey -D /etc/opendkim/keys/$DOMAIN/ -d $DOMAIN -s mail

/usr/bin/docker run \
  --rm \
  --name opendkim-genkey \
  -v /data/domains/mail/opendkim:/etc/opendkim \
  indiepaas/postfix \
  /bin/chown -R opendkim /etc/opendkim/keys

mv /data/domains/mail/opendkim/keys/$DOMAIN/mail.private /data/domains/mail/opendkim/keys/$DOMAIN/mail

echo mail._domainkey.$DOMAIN $DOMAIN:mail:/etc/opendkim/keys/$DOMAIN/mail >> /data/domains/mail/opendkim/KeyTable

echo *@$DOMAIN mail._domainkey.$DOMAIN >> /data/domains/mail/opendkim/SigningTable

echo $DOMAIN >> /data/domains/mail/opendkim/TrustedHosts
echo galaxy.$DOMAIN >> /data/domains/mail/opendkim/TrustedHosts

echo "Domain installed with success."
echo "Please add the followig records to it's DNS."

cat /data/domains/mail/opendkim/keys/$DOMAIN/mail.txt

echo "And don't forget spf :)"

