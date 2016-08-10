# Instructions to install LibrePaaS

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

# Add swap
fallocate -l 8192m /swap
chmod 600 /swap
mkswap /swap

cat > /var/lib/coreos-install/user_data << EOF
#cloud-config

hostname: $hostname
ssh_authorized_keys:
  - #your ssh public key here
write_files:
  - path: /etc/sysctl.d/aio-max.conf
    permissions: 0644
    owner: root
    content: "fs.aio-max-nr = 1048576"
  - path: /etc/hosts
    permissions: 0644
    owner: root
    content: |
      127.0.0.1 localhost
      255.255.255.255 broadcasthost
      ::1 localhost
  - path: /etc/environment
    permission: 0644
    owner: root
    content: |
      NAMECHEAP_URL="namecheap.com"
      NAMECHEAP_API_USER="pierreo"
      NAMECHEAP_API_KEY=
      IP=`curl -s http://icanhazip.com/`
      FirstName="Pierre"
      LastName="Ozoux"
      Address="23CalcadaSaoVicente"
      PostalCode="1100-567"
      Country="Portugal"
      Phone="+351.967184553"
      EmailAddress="pierre@ozoux.net"
      City="Lisbon"
      CountryCode="PT"
      BACKUP_DESTINATION=root@xxxxx:port
      MAIL_USER=contact%40indie.host
      MAIL_PASS=
      MAIL_HOST=mail.indie.host
      MAIL_PORT=587
coreos:
  update:
    reboot-strategy: off
  units:
    - name: systemd-sysctl.service
      command: restart
    - name: data.mount
      command: start
      content: |
        [Mount]
        What=/dev/md0
        Where=/data
        Type=ext4
    - name: swap.service
      command: start
      content: |
        [Service]
        Type=oneshot
        ExecStart=/sbin/swapon /swap
EOF

# Create Directory structure
git clone https://github.com/indiehosters/LibrePaaS.git /indiehosters
mkdir /{data,system}
mkdir /data/trash

mkdir -p /opt/bin

# Install unit-files and utils
cp /indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload
cp /indiehosters/utils/* /opt/bin/

DOCKER_COMPOSE_VERSION=1.6.0
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose
chmod +x /opt/bin/docker-compose
