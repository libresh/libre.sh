To run an IndieHosters on ubuntu 14.10 (earlier versions will not work), run something like:

  apt-get update && apt-get -y upgrade
  dpkg-reconfigure -plow unattended-upgrades
  # set unattended upgrades to 'Yes'
  apt-get -y install systemd-sysv git docker.io
  docker run -d --restart='always' -p 4001:4001  quay.io/coreos/etcd:v0.4.6
  echo "#!/bin/sh" > /usr/local/etcdctl
  echo "docker run --net=host quay.io/coreos/etcd:v0.4.6 /etcdctl $1 $2 $3 $4" >> /usr/local/etcdctl
  shutdown -r now

  systemctl start docker # This will be automatic once the IndieHosters unit-files are installed
  systemctl list-units
  docker ps
  etcdctl ls
  etcdctl help

Now follow the [CoreOS-based instructions](deploying-a-server.md)
