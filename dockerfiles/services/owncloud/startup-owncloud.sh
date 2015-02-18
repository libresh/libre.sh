#!/bin/bash -eux
###
# Check Pre Install
###

if [ -f /var/www/owncloud/config/config.php ]
then
  echo ">> owncloud already configured - skipping initialization"
  exit 0
fi

if [ ! -z ${OWNCLOUD_DO_NOT_INITIALIZE+x} ]
then
  echo ">> OWNCLOUD_DO_NOT_INITIALIZE set - skipping initialization"
  exit 0
fi

source /etc/environment

###
# Variables
###

if [ -z ${OWNCLOUD_IMAP_HOST+x} ]
then
  OWNCLOUD_IMAP_HOST=mail
fi

if [ -z ${DB_PORT+x} ]
then
  DB_PORT=3306
fi

if [ -z ${DB_NAME+x} ]
then
  DB_NAME=owncloud
fi

if [ -z ${EMAIL+x} ]
then
  EMAIL="admin"
  echo ">> owncloud admin user: $EMAIL"
fi

if [ -z ${ADMIN_PASSWORD+x} ]
then
  ADMIN_PASSWORD=`perl -e 'my @chars = ("A".."Z", "a".."z"); my $string; $string .= $chars[rand @chars] for 1..10; print $string;'`
  echo ">> generated owncloud admin password: $ADMIN_PASSWORD"
fi

###
# Pre Install
###

if [ ! -z ${OWNCLOUD_HSTS_HEADERS_ENABLE+x} ]
then
  echo ">> HSTS Headers enabled"
  sed -i 's/#add_header Strict-Transport-Security/add_header Strict-Transport-Security/g' /etc/nginx/conf.d/nginx-owncloud.conf

  if [ ! -z ${OWNCLOUD_HSTS_HEADERS_ENABLE_NO_SUBDOMAINS+x} ]
  then
    echo ">> HSTS Headers configured without includeSubdomains"
    sed -i 's/; includeSubdomains//g' /etc/nginx/conf.d/nginx-owncloud.conf
  fi
else
  echo ">> HSTS Headers disabled"
fi

###
# Headless initialization
###
echo ">> copy apps into apps folder."
cp -R /owncloud-apps/* /var/www/owncloud/apps/

echo ">>Setting Permissions:"
ocpath='/var/www/owncloud'
htuser='www-data'

chown -R root:${htuser} ${ocpath}/
chown -R ${htuser}:${htuser} ${ocpath}/apps/
chown -R ${htuser}:${htuser} ${ocpath}/config/
chown -R ${htuser}:${htuser} ${ocpath}/data/

echo ">> initialization"
echo ">> starting nginx to configure owncloud"
sleep 1
nginx > /tmp/nginx.log 2> /tmp/nginx.log &
sleep 1

## Create OwnCloud Installation
echo ">> init owncloud installation"
DATA_DIR=/var/www/owncloud/data

/opt/mysql-check.sh

if [ -z ${DB_USER+x} ] || [ -z ${DB_PASS+x} ]
then
  echo "We need user and password for database" 
  exit 1
else
  echo ">> using mysql DB"
  DB_TYPE="mysql"
  POST=`echo "install=true&adminlogin=$EMAIL&adminpass=$ADMIN_PASSWORD&adminpass-clone=$ADMIN_PASSWORD&directory=$DATA_DIR&dbtype=$DB_TYPE&dbuser=$DB_USER&dbpass=$DB_PASS&dbpass-clone=$DB_PASS&dbname=$DB_NAME&dbhost=$DB_HOST:$DB_PORT"`
fi

echo ">> using curl to post data to owncloud"
echo "POST = $POST"
curl -d "$POST" http://${URL}/index.php

echo ">> killing nginx - done with configuration"
sleep 1
killall nginx
echo ">> finished initialization"

