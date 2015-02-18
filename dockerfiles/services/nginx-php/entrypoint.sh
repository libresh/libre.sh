#!/bin/bash -eux

/etc/init.d/php5-fpm start
chmod a+rwx /var/run/php5-fpm.sock

echo "127.0.0.1 ${URL}" >> /etc/hosts

# exec CMD
echo ">> exec docker CMD"
echo "$@"
"$@"

