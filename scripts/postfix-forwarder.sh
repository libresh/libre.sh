#!/bin/bash -eux

docker stop postfix-forwarder
docker rm postfix-forwarder
docker run -p 25:25 -d --name="postfix-forwarder" -v /data/server-wide/postfix:/data indiehosters/postfix-forwarder
