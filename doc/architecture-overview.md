# Architecture based on systemd, docker, haproxy, and some bash scripts
Our architecture revolves around a
[set of systemd unit files](https://github.com/indiehosters/indiehosters/tree/master/unit-files). They come in various types:

## Server-wide processes

The haproxy.* and postfix.* unit files correspond to two server-wide processes. They run Docker containers from images in the
[server-wide/ folder of our dockerfiles repo](https://github.com/indiehosters/dockerfiles/tree/master/server-wide).
The haproxy-confd.* unit starts a side-kick service for haproxy, which monitors `etcdctl ls /services` to see if any new backends were created, and updates the haproxy configuration, which lives in `/data/server-wide/haproxy/` on the host sytem. It is required by the haproxy.* unit. That means that when you run `systemctl start haproxy`, and then run `docker ps` or `systemctl list-units`, you will see that systemd not only started the haproxy container, but also the haproxy-confd container.

There is currently no similar side-kick for updating `/data/server-wide/postfix/`, so you will have to update the configuration files in that folder manually, and then run `systemctl restart postfix`.

The `scripts/setup.sh` takes care of setting up etcd, enabling and starting the haproxy and postfix service (as well as one haproxy backend, to serve the default site), and the haproxy-confd side-kick to listen for changes in the backends configuration in etcd, so that new backends are automatically added to the haproxy config as soon as their IP address is written into etcd.

## HAProxy backends: nginx, wordpress, wordpress-subdir

A per-user process is a haproxy backend for a specific domain name. At the time of writing we have three applications available: nginx, wordpress, and wordpress-subdir.

You will notice there are also some other units in the `unit-files/` folder of this repo, like the gitpuller and mysql ones. Whenever you start a wordpress or a wordpress-subdir unit, it requires a mysql service.
Whenever you start a wordpress-subdir or an nginx unit, it wants a gitpuller unit. In all three cases, an -importer unit and a -discovery unit are required.
This works through a
[`Requires=` directive](https://github.com/indiehosters/indiehosters/blob/0.1.0/unit-files/nginx@.service#L6-L7) which systemd interprets, so that if you start one service, its dependencies are also started (you can see that in `systemctl list-units`).

## Discovery

The -discovery units check find out the local IP address of the backend, checks if it is up by doing a `curl`, and if so, writes the IP address into etcd. The `haproxy-confd` process notices this, and update the haproxy config.

## Import

The -import units check if data exists, and if it doesn't, create initial data state, for instance by doing a git clone, untarring the php files of a virgin wordpress installation, or both. So -import is actually a misnomer, probably -init would have been a better name.

Note that some initialization is also done by the Docker images themselves - for instance the wordpress image runs a [shell script](https://github.com/pierreozoux/tutum-docker-wordpress-nosql/blob/master/run-wordpress.sh) at container startup, that creates the initial mysql database if it didn't exist yet.

## Gitpuller

The -gitpuller unit is scheduled to run every 10 minutes by the .timer file, and is configure to only run if the GITURL file exists at the path specified in the .path file. When it runs, it does a git pull to update the website content at one of the haproxy backends from the git repository mentioned in the GITURL file.

## Scripts

There are two important scripts you can run at your server. You can also run the commands they contain manually, then you just use them as a cheatsheet of how to [set up a new server](https://github.com/indiehosters/indiehosters/tree/master/scripts/setup.sh) or [activate a new user](https://github.com/indiehosters/indiehosters/tree/master/scripts/activate-user.sh), respectively.

There are also deploy scripts which do the same from a jump box, so you can orchestrate multiple servers from one central vantage points. They are in the
[deploy/](https://github.com/indiehosters/indiehosters/tree/master/deploy)
 folder of this repo, and they are the scripts referred to in the 'how to deploy a server' document. They basically run the scripts from the scripts/ folder over ssh.
