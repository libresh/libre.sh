START

docker pull pierreozoux/haproxy
docker pull pierreozoux/confd
docker pull pierreozoux/email-forwarder
docker pull pierreozoux/nginx
docker pull pierreozoux/mysql
docker pull pierreozoux/wordpress
docker pull pierreozoux/known

mv /data/indiehosters /data/indiehosters.old
git clone https://github.com/pierreozoux/IndiePaaS.git /data/indiehosters

cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

systemctl disable postfix
systemctl disable haproxy-confd
systemctl enable email-forwarder
systemctl enable confd

reboot

STOP

ROLLBACK START

mv /data/indiehosters /data/indiehosters.new
mv /data/indiehosters.old /data/indiehosters
cp /data/indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload

systemctl enable postfix
systemctl enable haproxy-confd
systemctl disable email-forwarder
systemctl disable confd

reboot
ROLLBACK STOP

CLEAN START
rm /etc/systemd/system/postfix.service
rm /etc/systemd/system/haproxy-confd.service
rm -rf /data/indiehosters.old
CLEAN STOP

