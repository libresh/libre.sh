#!/bin/bash -eux

export DB_PORT=3306
export DB_HOST=db
export DB_USER=admin
echo $HOSTNAME

sed -i "s/##DB_HOST##/$DB_HOST/" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s/##DB_USER##/$DB_USER/" /etc/dovecot/dovecot-sql.conf.ext
sed -i "s/##DB_PASS##/$DB_PASS/" /etc/dovecot/dovecot-sql.conf.ext

/opt/editconf.py /etc/dovecot/conf.d/15-lda.conf postmaster_address=postmaster@$HOSTNAME

/opt/mysql-check.sh

DB_EXISTS=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -e "SHOW DATABASES LIKE 'servermail';" 2>&1 |grep servermail > /dev/null ; echo "$?")
if [[ DB_EXISTS -eq 1 ]]; then
  echo "=> Creating database servermail"
  RET=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -e "CREATE DATABASE servermail")
  if [[ RET -ne 0 ]]; then
    echo "Cannot create database for emails"
    exit RET
  fi
  echo "=> Loading initial database data to servermail"
  RET=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT servermail < /init.sql)
  if [[ RET -ne 0 ]]; then
    echo "Cannot load initial database data for emails"
    exit RET
  fi
  echo "=> Done!"
else
  echo "=> Skipped creation of database servermail it already exists."
fi

dovecot -F

