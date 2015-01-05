# HAproxy

The smallest HAproxy docker image in town ;)

## Run

This image will log everything to stdout/stderr. Somehow, it respects 12-Factor App. But it uses the debug flag of HAProxy. If you have a better idea, please read this [blog post](http://pierre-o.fr/blog/2014/08/27/haproxy-coreos/) first.

```bash
docker run\
  -v /haproxy-config:/etc/haproxy\
  -p 80:80\
  -p 443:443\
  indiehosters/haproxy
```

Have a look to [indiehosters/confd](https://registry.hub.docker.com/u/indiehosters/confd/) to have automatic configuration of HAproxy backed by `etcd` or `consul`.
