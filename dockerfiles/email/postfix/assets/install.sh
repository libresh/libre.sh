#!/bin/bash

#judgement
if [[ -a /etc/supervisor/conf.d/supervisord.conf ]]; then
  exit 0
fi

#supervisor
cat > /etc/supervisor/conf.d/supervisord.conf <<EOF
[supervisord]
nodaemon=true

[program:postfix]
command=/opt/postfix.sh

[program:rsyslog]
command=/usr/sbin/rsyslogd -n
EOF

############
# postfix
############
cat >> /opt/postfix.sh <<EOF
#!/bin/bash
service postfix start
touch /var/log/mail.log
tail -f /var/log/mail.log
EOF
chmod +x /opt/postfix.sh

# put the same FQDN in /data/hostname and in reverse DNS
# for the public IP address on which this server will be
# receiving smtp traffic.
cp /data/hostname /etc/mailname
/usr/sbin/postconf -e "myhostname=`cat /data/hostname`"

# put all relevant domains in /data/destinations.
/usr/sbin/postconf -e "mydestination=`cat /data/destinations`"

#put your forwarding addresses in /data/forwards.
echo "virtual_maps = hash:/etc/postfix/virtual, regexp:/etc/postfix/virtual-regexp" >> /etc/postfix/main.cf
cp /data/forwards /etc/postfix/virtual-regexp
postmap /etc/postfix/virtual-regexp
touch /etc/postfix/virtual
postmap /etc/postfix/virtual
