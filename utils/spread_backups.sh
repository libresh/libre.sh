#!/bin/bash -eux

for unit in `systemctl list-units --all backup@*service | grep "Back up data" | cut -d" " -f2 | grep backup | sort -R`
do
  systemctl stop $unit
  systemctl restart $unit
done

for unit in `systemctl list-units --all backup@*service | grep "Back up data" | cut -d" " -f3 | grep backup | sort -R`
do
  systemctl stop $unit
  systemctl restart $unit
done

for unit in `systemctl list-units --all backup@*service | grep "Back up data" | cut -d" " -f1 | grep backup | sort -R`
do
  systemctl stop $unit
  systemctl restart $unit
done

