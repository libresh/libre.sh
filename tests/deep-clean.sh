#!/bin/bash -eux

image=$1
BACKUP_DESTINATION=`cat /data/BACKUP_DESTINATION`

/data/indiehosters/tests/clean-image.sh $image

ssh $BACKUP_DESTINATION "rm -rf $image.test"
