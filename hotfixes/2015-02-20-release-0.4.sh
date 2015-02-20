START

cd /data/indiehosters
git pull

docker pull pierreozoux/rsyslog
docker pull pierreozoux/haproxy
docker pull pierreozoux/confd
docker pull pierreozoux/postfix
docker pull pierreozoux/nginx
docker pull pierreozoux/mysql
docker pull pierreozoux/wordpress
docker pull pierreozoux/known
docker pull pierreozoux/piwik
docker pull pierreozoux/owncloud

systemctl enable rsyslog
systemctl start  rsyslog
systemctl enable postfix
systemctl disable email-forwarder

cp /data/indiehosters/unit-files/* /etc/systemd/system

reboot

STOP
