#!/bin/bash -eux

image=$1

/data/indiehosters/tests/runtime-clean-image.sh $image
rm -rf /data/domains/$image.test

ssh core@backup.dev "rm -rf $image.test"
