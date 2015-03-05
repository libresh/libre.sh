#!/bin/bash -eux

export DB_PORT=3306
export DB_HOST=db
export DB_USER=admin
echo $HOSTNAME

sed -i "s/##DB_USER##/$DB_USER/" /etc/postfix/virtual-mailbox-domains.cf
sed -i "s/##DB_PASS##/$DB_PASS/" /etc/postfix/virtual-mailbox-domains.cf
sed -i "s/##DB_USER##/$DB_USER/" /etc/postfix/virtual-mailbox-maps.cf
sed -i "s/##DB_PASS##/$DB_PASS/" /etc/postfix/virtual-mailbox-maps.cf
sed -i "s/##DB_USER##/$DB_USER/" /etc/postfix/virtual-alias-maps.cf
sed -i "s/##DB_PASS##/$DB_PASS/" /etc/postfix/virtual-alias-maps.cf
sed -i "s/##HOSTNAME##/$HOSTNAME/" /etc/postfix/virtual-alias-maps.cf
sed -i "s/##HOSTNAME##/$HOSTNAME/" /etc/postfix/main.cf

/opt/mysql-check.sh

chown -R postfix:postfix /var/spool/postfix/dovecot

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:postfix]
process_name = master
command = /etc/init.d/postfix start
startsecs = 0
autorestart = false

EOF

