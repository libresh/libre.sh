#!/bin/bash -eux

image=$1

systemctl stop *@$image.test.timer
systemctl stop *@$image.test
systemctl reset-failed
systemctl list-units | grep -c "$image\.test" | grep 0
rm -rf /data/import/$image.test
rm -rf /data/runtime/domains/$image.test
