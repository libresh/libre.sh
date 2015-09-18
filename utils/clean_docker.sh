#!/bin/bash

docker rm `docker ps -a -q`
docker rmi `docker images -a -q`
/opt/bin/docker-volumes rm `/opt/bin/docker-volumes list | grep docker | cut -d"|" -f1`
