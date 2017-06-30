# HowTo install Libre.sh on Debian

## MOTIVATION
- Because some provider don't offer CoreOS and/or to push your ISO;
- Because some client prefer "wellknown" linux distribution;

So instead of reinvented the wheel, and to finally proof Libre.sh could work on any Systemd Linux *(yep I ran it before on CentOS7)* I decide to make that proof of concept.

## REQUIREMENT
- Systemd (debian 8 or debian 9)

## HOWTO
Where basicly reproduce what the user_data do for us.

## Let's make a step-by-step humanable readable.
as root

### SSHD Config
Don't forget to create the user core and adding your ssh key before
You could also remove AllowUsers core or/and change the username.  
> cat > /etc/ssh/sshd_config <<EOF  
UsePrivilegeSeparation sandbox  
Subsystem sftp internal-sftp  
PermitRootLogin no  
AllowUsers core  
PasswordAuthentication no  
ChallengeResponseAuthentication no  
EOF  
> chmod 600 /etc/ssh/sshd_config  
> systemctl restart sshd  

### Kernel Parameter
> cat > /etc/sysctl.d/libresh.conf <<EOF  
fs.aio-max-nr=1048576  
vm.max_map_count=262144  
EOF  
> chmod 644 /etc/sysctl.d/libresh.conf
> sysctl -p  

### Localhost definition
> cat > /etc/hosts <<EOF  
127.0.0.1 localhost  
255.255.255.255 broadcasthost  
::1 localhost  
EOF  

### Envrionment definition (optional)
Don't forget to edit /etc/environment with your own variable
such as example :  
**The 1st part** Pierre use Namecheap.com as a Domain Name Provider, which support command through API. This make possible to buy domainname and fill the info with these above.  
**In the second part** It's a common configuration to send email, often from the system.  

> cat > /etc/environment <<EOF  
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

### Install docker-compose
*Remark I did a variante to find the last version of DockerCompose and download it*
> mkdir -p /opt/bin &&\  
~~> url=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r \'.assets[].browser_download_url | select(contains("Linux") and contains("x86_64"))\') &&\  
> curl -L $url > /opt/bin/docker-compose &&\~~  
> dockerComposeVersion=$(curl -s https://api.github.com/repos/docker/compose/releases/latest|grep tag_name|cut -d'"' -f4) &&\  
> curl -L https://github.com/docker/compose/releases/download/$dockerComposeVersion/docker-compose-`uname -s`-`uname -m` > /opt/bin/docker-compose &&\  
> chmod +x /opt/bin/docker-compose  

#### Explanation line by line
1. create /opt/bin
2. determine the last version of docker-compose
3. download the last version of docker-compose in /opt/bin
4. make it executable

### Install Libre.sh
> git clone https://github.com/indiehosters/libre.sh.git /libre.sh &&\  
> mkdir /{data,system} &&\  
> mkdir /data/trash &&\  
> cp /libre.sh/unit-files/* /etc/systemd/system && systemctl daemon-reload &&\  
> systemctl enable web-net.service &&\  
> systemctl start web-net.service &&\  
> cp /libre.sh/utils/* /opt/bin/  

#### Explanation line by line
1. clone libre.sh from indiehosters profile on github
2. create /data et /system	*# I recommand to use separate partition or even better disk.*
3. create /data/trash		*# don't forget to mount /data before*
4. copy unit-files into systemd
5. enable web-net service
6. start web-net service	*# be sure you did'nt create lb_web network before or it will fail*
7. copy libre.sh tool's in /opt/bin


### Add PATH /opt/bin
It's possible you have to had /opt/bin into your PATH
> cat > /etc/profile.d/libre.sh <<EOF  
export PATH=$PATH:/opt/bin  
EOF  
chmod 644 /etc/profile.d/libre.sh  
