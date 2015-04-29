#!/bin/bash -e

function cleanup {
  /etc/init.d/haproxy stop
  /etc/init.d/rsyslog stop
  exit 0
}

# start haproxy in bg and tail logs out to stdout
/usr/sbin/service rsyslog start
/etc/init.d/haproxy start
tail -f /var/log/syslog &
tail -f /var/log/haproxy.log &

trap cleanup SIGTERM SIGINT

while true; do # Iterate to keep job running.
  sleep 1 # Don't sleep too long as signals will not be handled during sleep.
done

