#!/bin/sh
for i in `deploy/list-sites.sh $1`; do
  echo "Approving combined cert for $i";
  cp ../orchestration/TLS/combined/$i.pem ../orchestration/TLS/approved-certs/$i.pem;
  scp ../orchestration/TLS/approved-certs/$i.pem root@$1:/data/server-wide/haproxy/approved-certs/
done
