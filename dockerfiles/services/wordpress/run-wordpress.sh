#!/bin/bash

chown -R root:www-data /app
chmod -R 650 /app
chmod -R 770 /app/wp-content/
chmod -R 660 /app/.htaccess

if [ -f /.mysql_db_created ]; then
        exec /run.sh
        exit 1
fi

DB_HOST=${DB_PORT_3306_TCP_ADDR:-${DB_HOST}}
DB_HOST=${DB_1_PORT_3306_TCP_ADDR:-${DB_HOST}}
DB_PORT=${DB_PORT_3306_TCP_PORT:-${DB_PORT}}
DB_PORT=${DB_1_PORT_3306_TCP_PORT:-${DB_PORT}}

if [ "$DB_PASS" = "**ChangeMe**" ] && [ -n "$DB_1_ENV_MYSQL_PASS" ]; then
    DB_PASS="$DB_1_ENV_MYSQL_PASS"
fi

echo "=> Trying to connect to MySQL/MariaDB using:"
echo "========================================================================"
echo "      Database Host Address:  $DB_HOST"
echo "      Database Port number:   $DB_PORT"
echo "      Database Name:          $DB_NAME"
echo "      Database Username:      $DB_USER"
echo "      Database Password:      $DB_PASS"
echo "========================================================================"

for ((i=0;i<10;i++))
do
    DB_CONNECTABLE=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -e 'status' >/dev/null 2>&1; echo "$?")
    if [[ DB_CONNECTABLE -eq 0 ]]; then
        break
    fi
    sleep 5
done

if [[ $DB_CONNECTABLE -eq 0 ]]; then
    DB_EXISTS=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -e "SHOW DATABASES LIKE '"$DB_NAME"';" 2>&1 |grep "$DB_NAME" > /dev/null ; echo "$?")

    if [[ DB_EXISTS -eq 1 ]]; then
        echo "=> Creating database $DB_NAME"
        RET=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT -e "CREATE DATABASE $DB_NAME")
        if [[ RET -ne 0 ]]; then
            echo "Cannot create database for wordpress"
            exit RET
        fi
        if [ -f /initial_db.sql ]; then
            echo "=> Loading initial database data to $DB_NAME"
            RET=$(mysql -u$DB_USER -p$DB_PASS -h$DB_HOST -P$DB_PORT $DB_NAME < /initial_db.sql)
            if [[ RET -ne 0 ]]; then
                echo "Cannot load initial database data for wordpress"
                exit RET
            fi
        fi
        echo "=> Done!"
    else
        echo "=> Skipped creation of database $DB_NAME – it already exists."
    fi
else
    echo "Cannot connect to Mysql"
    exit $DB_CONNECTABLE
fi

touch /.mysql_db_created
exec /run.sh
