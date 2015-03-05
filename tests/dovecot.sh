#!/bin/bash -eux

mkdir -p /data/domains/mail/dovecot
mkdir -p /data/domains/mail/TLS
mkdir -p /data/domains/mail/static/www-content
mkdir -p /data/runtime/domains/mail/mysql/db_files
mkdir -p /data/domains/mail/mysql
mkdir /data/domains/mail/nginx
touch /data/domains/mail/nginx/.env

pass=`echo $RANDOM  ${date} | md5sum | base64 | cut -c-10`
echo MYSQL_PASS=$pass > /data/domains/mail/mysql/.env
cat /data/domains/mail/mysql/.env | sed s/MYSQL_PASS/DB_PASS/ > /data/domains/mail/.env;
echo HOSTNAME=dovecot.test >> /data/domains/mail/.env
echo APPLICATION=nginx >> /data/domains/mail/.env
echo DOCKER_ARGUMENTS="-v /data/domains/mail/static/www-content:/app" >> /data/domains/mail.env

openssl genrsa -out /data/domains/mail/TLS/ssl_private_key.pem 2048
openssl req -new -key /data/domains/mail/TLS/ssl_private_key.pem -out /data/domains/mail/TLS/ssl_cert_sign_req.csr \
  -sha256 -subj "/C=PT/ST=/L=/O=/CN=dovecot.test"
openssl x509 -req -days 365 \
  -in /data/domains/mail/TLS/ssl_cert_sign_req.csr -signkey /data/domains/mail/TLS/ssl_private_key.pem -out /data/domains/mail/TLS/ssl_certificate.pem
openssl dhparam -out /data/domains/mail/TLS/dh2048.pem 2048

cp /data/domains/mail/TLS/ssl_certificate.pem /data/domains/mail/TLS/mail.pem

systemctl start dovecot

