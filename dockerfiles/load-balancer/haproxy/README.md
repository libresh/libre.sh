# HAproxy

The smallest HAproxy docker image in town ;)

## Run

```bash
docker run\
  -v /haproxy-config:/etc/haproxy\
  -p 80:80\
  -p 443:443\
  indiepaas/haproxy
```

Have a look to [indiepaas/confd](https://registry.hub.docker.com/u/indiepaas/confd/) to have automatic configuration of HAproxy backed by `etcd` or `consul`.
