# Confd

The smallest confd docker image in town ;)

## Run

This image will log everything to stdout/stderr.

It was designed to work with HAproxy, but you can use it for anything! There is no configuration, you'll have to mount the config folder. There is a nice example in [indiehosters/confd git repo](https://github.com/indiehosters/dockerfiles/tree/master/server-wide/confd).

```bash
docker run\
  -v /haproxy-config:/etc/haproxy/\
  -v ./confd/:/etc/confd/\
  -v /var/run/docker.sock:/var/run/docker.sock\
indiehosters/confd
```

It works really well with [indiehosters/haproxy](https://registry.hub.docker.com/u/indiehosters/haproxy/) to have automatic configuration of HAproxy backed by `etcd` or `consul`.
