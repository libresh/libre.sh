# Instructions to install LibrePaaS

## Requirements

- API key on Namecheap

## Recommendation
- ssd on /dev/sda
- hdd on /dev/sdb
- hdd on /dev/sdc

# Installation

Replace the following variables with yours:
IP
hostname

```

ssh -o "StrictHostKeyChecking no" root@$IP

fdisk -l #find your ssd

# Setup raid
cat > /etc/mdadm.conf << EOF
MAILADDR dev@null.org
EOF
mdadm --create --verbose /dev/md0 --level=mirror --raid-devices=2 /dev/sdb /dev/sdc
mkfs.ext4 /dev/md0

cat > cloud-config.tmp << EOF
#cloud-config

hostname: $hostname
ssh_authorized_keys:
  - #your ssh public key here
EOF

wget https://raw.github.com/coreos/init/master/bin/coreos-install
bash coreos-install -d /dev/sda -c cloud-config 

reboot
```

```
ssh core@$IP
sudo su -

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

# Install unit-files and utils
cp /indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload
cp /indiehosters/utils/* /opt/bin/

mkdir -p /opt/bin
DOCKER_COMPOSE_VERSION=1.6.0
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose
chmod +x /opt/bin/docker-compose
