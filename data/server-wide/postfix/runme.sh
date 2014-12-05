docker rm postfix
docker run -d --name postfix -v $(pwd):/data -p 25:25 indiehosters/postfix-forwarder
