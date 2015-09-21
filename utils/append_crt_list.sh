#!/bin/bash -eux

domain=$1

echo "/etc/haproxy/approved-certs/$domain.pem $domain" >> /data/runtime/haproxy/crt-list
echo "/etc/haproxy/approved-certs/$domain.pem www.$domain" >> /data/runtime/haproxy/crt-list
