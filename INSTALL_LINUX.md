# Instructions to install libre.sh on linux with Systemd

## Recommendation
- Systemd (debian 8 or debian 9, CentOS 7 ...)

# Installation
Where basicly reproduce what the user_data do for us.

as root

# configure sshd
Don't forget to create the user core and adding your ssh key before
You could also remove AllowUsers core or/and change the username.

```
cat > /etc/ssh/sshd_config <<EOF
UsePrivilegeSeparation sandbox
Subsystem sftp internal-sftp
PermitRootLogin no
AllowUsers core
PasswordAuthentication no
ChallengeResponseAuthentication no
EOF
chmod 600 /etc/ssh/sshd_config
systemctl restart sshd
```

# add kernel parameter

```
cat > /etc/sysctl.d/libresh.conf <<EOF
fs.aio-max-nr=1048576
vm.max_map_count=262144
vm.overcommit_memory=1
EOF
chmod 644 /etc/sysctl.d/libresh.conf
sysctl -p /etc/sysctl.d/libresh.conf

echo never > /sys/kernel/mm/transparent_hugepage/enabled
```

# define Localhost

```
cat > /etc/hosts <<EOF
127.0.0.1 localhost
255.255.255.255 broadcasthost
::1 localhost
EOF
```

# define envrionment

```
cat > /etc/environment <<EOF
NAMECHEAP_URL="namecheap.com"
NAMECHEAP_API_USER="pierreo"
NAMECHEAP_API_KEY=
IP="curl -s http://icanhazip.com/"
FirstName="Pierre"
LastName="Ozoux"
Address=""
PostalCode=""
Country="Portugal"
Phone="+351.967184553"
EmailAddress="pierre@ozoux.net"
City="Lisbon"
CountryCode="PT"
BACKUP_DESTINATION=root@xxxxx:port
MAIL_USER=
MAIL_PASS=
MAIL_HOST=mail.indie.host
MAIL_PORT=587
EOF
```

# install docker-compose

*Remark I did a variante to find the last version of DockerCompose and download it*

```
mkdir -p /opt/bin &&\
dockerComposeVersion=$(curl -s https://api.github.com/repos/docker/compose/releases/latest|grep tag_name|cut -d'"' -f4) &&\
curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose &&\
chmod +x /opt/bin/docker-compose
```
# install Libre.sh

```
git clone https://github.com/indiehosters/libre.sh.git /libre.sh &&\
mkdir /{data,system} &&\
mkdir /data/trash &&\
cp /libre.sh/unit-files/* /etc/systemd/system && systemctl daemon-reload &&\
systemctl enable web-net.service &&\
systemctl start web-net.service &&\
cp /libre.sh/utils/* /opt/bin/
```

# add /opt/bin path

```
cat > /etc/profile.d/libre.sh <<EOF
export PATH=$PATH:/opt/bin
EOF
chmod 644 /etc/profile.d/libre.sh
```
