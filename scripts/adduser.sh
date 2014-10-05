#!/bin/bash -eux

# Start service for new site (and create the user)
systemctl enable $2@$1.service
systemctl start  $2@$1.service

sleep 10

# Configure new site in HAproxy
IP=`docker inspect --format '{{.NetworkSettings.IPAddress}}' $2-$1`

echo IP address of new container \'$2-$1\' is \'$IP\'
sed s/%HOSTNAME%/$1/g /data/infrastructure/templates/haproxy-frontend.part | sed s/%IP%/$IP/g >> /data/server-wide/haproxy/frontends.part
sed s/%HOSTNAME%/$1/g /data/infrastructure/templates/haproxy-backend.part | sed s/%IP%/$IP/g >> /data/server-wide/haproxy/backends.part
cat /data/server-wide/haproxy/haproxy-main.part /data/server-wide/haproxy/frontends.part /data/server-wide/haproxy/backends.part > /data/server-wide/haproxy/haproxy.cfg
systemctl reload haproxy.service
