#!/bin/bash

cd
cp /etc/environment .
cp /var/lib/coreos-install/user_data .
tar cvzf /home/core/root-k4.tgz --exclude ./.cache/* .
chown core:core /home/core/root-k4.tgz

echo 'scp core@k4:root-k4.tgz .'

