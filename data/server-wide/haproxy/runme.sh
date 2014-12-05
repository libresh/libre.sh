docker rm haproxy
docker run -d --restart=always --name haproxy -v $(pwd):/etc/haproxy -p 80:80 -p 443:443 \
  --link michielbdejong.com:michielbdejong.com-backend \
  --link otherdomain.com:otherdomain.com-backend \
  indiehosters/haproxy
