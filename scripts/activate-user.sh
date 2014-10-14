#!/bin/bash -eux

# Start service for new site (and create the user)
systemctl enable $2@$1.service
systemctl start  $2@$1.service
