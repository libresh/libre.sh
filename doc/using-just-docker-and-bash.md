# Using just Docker and bash

## WARNING: Still a work-in-process

Given that CoreOS is not available everywhere, and the Ubuntu 14.10 setup with etcdctl inside a Docker instance still has some problems,
I'll try if I can run all our services (postfix-forwarder, haproxy, and the various web backend containers) on an off-the-shelf Ubuntu 14.04 server. Here's what I did to prepare the server:

````bash
apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade
apt-get -y install unattended-upgrades
dpkg-reconfigure -plow unattended-upgrades
# set unattended upgrades to 'Yes'
apt-get -y install docker.io
ssh-keygen -t rsa
````

Then I added the .ssh/id_rsa.pub to .ssh/authorized_keys at both backup server accounts, and ran:

````
mkdir -p /data
cd /data
git clone git@bu25:postfix
git clone git@bu25:haproxy
docker run -d -v /data/haproxy:/etc/haproxy -p 80:80 -p 443:443 indiehosters/haproxy
docker run -d --name postfix-forwarder -v /data/postfix:/data -p 25:25 indiehosters/postfix-forwarder 
````

And then for each domain I host:

````
cd /data
git clone git@bu25:michielbdejong.com
docker run -d --name michielbdejong.com -v /data/michielbdejong.com:/data indiehosters/lamp-git
````

Now the only thing you need to do is to get each backend IP address from `docker inspect michielbdejong.com` and edit `/data/runtime/haproxy/haproxy.cfg` with the correct IP address.
