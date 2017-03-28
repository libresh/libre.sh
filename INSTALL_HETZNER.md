# Instructions to install libre.sh

## Recommendation
- ssd on /dev/sda
- hdd on /dev/sdb
- hdd on /dev/sdc
- API key on Namecheap (if you want to automatically buy domain name)

# Installation

First, you need a server.
We recommend [Hetzner](https://serverboerse.de/index.php?country=EN) as they are the cheapest options around.
You can filter servers with ssd.

These instructions can also work on any VM/VPS/Hardware.

## Install the system

```
IP=

ssh -o "StrictHostKeyChecking no" root@$IP

hostname=
ssh_public_key=""

fdisk -l #find your ssd

# Setup raid
cat > /etc/mdadm.conf << EOF
MAILADDR dev@null.org
EOF
mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb /dev/sdc
mkfs.ext4 /dev/md0

cat > cloud-config.tmp << EOF
#cloud-config

hostname: "$hostname"
ssh_authorized_keys:
  - $ssh_public_key
EOF

apt-get install gawk
wget https://raw.github.com/coreos/init/master/bin/coreos-install
bash coreos-install -d /dev/sda -c cloud-config.tmp

reboot
```

```
ssh core@$IP

#configure mdmonitor.

sudo su -

mdadm --examine --scan > /etc/mdadm.conf
vim /etc/mdadm.conf
#ADD your mail
MAILADDR xxx@xxx.org

# Start service
systemctl start  mdmonitor.service

cat > /etc/systemd/system/data.mount << EOF
[Mount]
What=/dev/md0
Where=/data
Type=ext4
EOF

wget https://raw.githubusercontent.com/indiehosters/libre.sh/master/user_data -O /var/lib/coreos-install/user_data

coreos-cloudinit /var/lib/coreos-install/user_data
