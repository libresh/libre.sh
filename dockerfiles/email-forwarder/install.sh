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
postmap /etc/postfix/virtual
service postfix restart
EOF
chmod +x /opt/postfix.sh

# put the same FQDN in /data/hostname and in reverse DNS
# for the public IP address on which this server will be
# receiving smtp traffic.
cp /data/hostname /etc/mailname
/usr/sbin/postconf -e "myhostname=`cat /data/hostname`"

# put all relevant domains in /data/destinations.
/usr/sbin/postconf -e "virtual_alias_domains=`cat /data/destinations`"

#put your forwarding addresses in /data/forwards.
cp /data/forwards /etc/postfix/virtual
/usr/sbin/postconf -e "virtual_alias_maps = hash:/etc/postfix/virtual"

# accept mails from docker networked machines:
/usr/sbin/postconf -e "mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 172.17.42.0/24"

