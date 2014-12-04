# Using just Docker and bash

## WARNING: Still a work-in-process

Given that CoreOS is not available everywhere, and the Ubuntu 14.10 setup with etcdctl inside a Docker instance still has some problems,
I'll try if I can run all our services (postfix-forwarder, haproxy, and the various web backend containers) on an off-the-shelf Ubuntu 14.04 server. Here's what I did to prepare the server (not all servers support Docker, because of kernel modules etcetera; I used Ubuntu 12.04-64 at Gandi, and gave it 5GB of disk space and 512Mb of RAM):

````bash
apt-get update && apt-get -y upgrade
apt-get -y install unattended-upgrades curl git
dpkg-reconfigure -plow unattended-upgrades
# set unattended upgrades to 'Yes'
curl -s https://get.docker.io/ubuntu/ | sh
ssh-keygen -t rsa
````

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
cd /data
git clone git@bu25:michielbdejong.com
cd michielbdejong.com; ./runme.sh --behind-haproxy; cd ..
````

TODO: document how to create and update such web app migration archives.

Now the only thing you need to do is to get each backend IP address from `docker inspect michielbdejong.com` and edit `/data/haproxy/haproxy.cfg` with the correct IP address (the idea of the `--behind-haproxy` flag would be to automate that; note that the migration format here does not include the postfix-forwarder, DNS, and DNR data).
