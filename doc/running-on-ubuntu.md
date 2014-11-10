To run an IndieHosters on ubuntu 14.10 (earlier versions will not work), run something like:

````bash
apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
dpkg-reconfigure -plow unattended-upgrades
# set unattended upgrades to 'Yes'
apt-get -y install systemd-sysv git docker.io
printf '#!/bin/sh\ndocker run --net=host quay.io/coreos/etcd:v0.4.6 /etcdctl $1 $2 $3 $4' > /usr/local/bin/etcdctl
printf "[Unit]\nRequires=docker.service\nAfter=docker.service\n[Service]\nRestart=always\n\
ExecStartPre=-/usr/bin/docker kill etcd\n\
ExecStartPre=-/usr/bin/docker rm etcd\n\
ExecStart=/usr/bin/docker run \
  --name etcd \
  -p 4001:4001 \
  quay.io/coreos/etcd:v0.4.6\n\
ExecReload=/usr/bin/docker restart etcd\n\
ExecStop=/usr/bin/docker stop etcd\n\
[Install]\n\
WantedBy=multi-user.target\n" > /etc/systemd/system/etcd.service
shutdown -r now
````

````
systemctl enable etcd
systemctl start etcd
systemctl list-units
docker ps
etcdctl ls
etcdctl help
````

Be aware that this will expose etcd on port 4001, also on the public IP address, so if you are using this in production the it is very important to block this port on the firewall.
Now follow the [CoreOS-based instructions](deploying-a-server.md)

