#!/bin/bash -eux

image=$1

/data/indiehosters/tests/clean-image.sh $image

ssh core@backup.dev "rm -rf $image.test"
