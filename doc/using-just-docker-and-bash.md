# Using just Docker and bash

## WARNING: Still a work-in-process

Given that CoreOS is not available everywhere, and the Ubuntu 14.10 setup with etcdctl inside a Docker instance still has some problems,
I'll try if I can run all our services (postfix-forwarder, haproxy, and the various web backend containers) on an off-the-shelf Ubuntu server.
Note that not all servers support Docker, because of kernel modules etcetera; of the images I tried at Gandi, only the Ubuntu 12.04-64 one
allowed me to actually run `docker ps`, and even on there, I was not able to run `docker run debian apt-get update` because from the looks
of it, containers are not allowed to contact the outside world. In the end I got an Ubuntu 14.10 server at Rackspace.
Note that about 5GB of disk space will be used, and when running multiple sites, 1Gb of RAM is probably also well-spent.
Here's what I did to prepare the server:

````bash
apt-get update && apt-get -y upgrade
apt-get -y install unattended-upgrades docker.io git

dpkg-reconfigure -plow unattended-upgrades
# set unattended upgrades to 'Yes'

ssh-keygen -t rsa
# select all the defaults by hitting <enter> repeatedly
````

Test your server by running `docker run debian apt-get update` (there should be no 'could not resolve' errors).

Then I added the .ssh/id_rsa.pub to .ssh/authorized_keys at both backup server accounts, and ran:

````
git clone git@bu25:postfix
cd postfix; ./runme.sh; cd ..
git clone git@bu25:haproxy
cd haproxy; ./runme.sh; cd ..
````

TODO: document how to create and update such postfix and haproxy migration archives.

And then for each domain I host:

````
git clone git@bu25:michielbdejong.com
cd michielbdejong.com; ./runme.sh; cd ..
````

TODO: document how to create and update such web app migration archives.

Now the only thing you need to do is to get each backend IP address from `docker inspect michielbdejong.com` and edit `/data/haproxy/haproxy.cfg` with the correct IP address.

The idea of this setup would be to eventually make the migration format support both single-tennant and multi-tennant setups out of the box, but for now, the per-user migration archives are just the haproxy backends, and does not include the postfix, haproxy, DNS, and DNR data.
