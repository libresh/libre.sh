FROM indiepaas/base-email

RUN apt-get update && \
    apt-get install -q -y \
      postfix \
      postfix-pcre \
      postfix-mysql \
      supervisor \
      ca-certificates \
      opendkim \
      opendkim-tools \
      opendmarc && \
    rm -rf /var/lib/apt/lists/*

COPY install.sh /install.sh
COPY postfix_outgoing_mail_header_filters /etc/postfix/outgoing_mail_header_filters
COPY virtual-mailbox-domains.cf /etc/postfix/virtual-mailbox-domains.cf
COPY virtual-mailbox-maps.cf /etc/postfix/virtual-mailbox-maps.cf
COPY virtual-alias-maps.cf /etc/postfix/virtual-alias-maps.cf
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN \
  chmod u+x /install.sh && \
  /opt/editconf.py /etc/postfix/main.cf \
    inet_interfaces=all \
    myhostname=##HOSTNAME##\
    smtpd_banner="\$myhostname ESMTP Hi, I'm a hosted by an IndieHoster (Debian/Postfix; see https://indiehosters.net/)" \
    mydestination=localhost && \
  /opt/editconf.py /etc/postfix/master.cf -s -w \
    "submission=inet n       -       -       -       -       smtpd -o syslog_name=postfix/submission -o smtpd_milters=inet:127.0.0.1:8891 -o smtpd_tls_ciphers=high -o smtpd_tls_protocols=!SSLv2,!SSLv3 -o cleanup_service_name=authclean" && \
  /opt/editconf.py /etc/postfix/master.cf -s -w \
    "authclean=unix  n       -       -       -       0       cleanup -o header_checks=pcre:/etc/postfix/outgoing_mail_header_filters" && \
 /opt/editconf.py /etc/postfix/main.cf \
    smtpd_tls_security_level=may\
    smtpd_tls_auth_only=yes \
    smtpd_tls_cert_file=/ssl/ssl_certificate.pem \
    smtpd_tls_key_file=/ssl/ssl_private_key.pem \
    smtpd_tls_dh1024_param_file=/ssl/dh2048.pem \
    smtpd_tls_received_header=yes && \
  /opt/editconf.py /etc/postfix/main.cf \
    smtpd_relay_restrictions=permit_sasl_authenticated,permit_mynetworks,reject_unauth_destination && \
  /opt/editconf.py /etc/postfix/main.cf \
    smtp_tls_CAfile=/etc/ssl/certs/ca-certificates.crt \
    smtp_tls_loglevel=2 && \
  /opt/editconf.py /etc/postfix/main.cf virtual_transport=lmtp:[127.0.0.1]:10025 && \
  /opt/editconf.py /etc/postfix/main.cf virtual_transport=lmtp:unix:dovecot/lmtp && \
  /opt/editconf.py /etc/postfix/main.cf \
    smtpd_sender_restrictions="reject_non_fqdn_sender,reject_unknown_sender_domain,reject_rhsbl_sender dbl.spamhaus.org" \
    smtpd_recipient_restrictions=permit_sasl_authenticated,permit_mynetworks,"reject_rbl_client zen.spamhaus.org",reject_unlisted_recipient && \
  /opt/editconf.py /etc/postfix/main.cf \
    message_size_limit=134217728 && \
  /opt/editconf.py /etc/postfix/main.cf \
    smtpd_sasl_type=dovecot \
    smtpd_sasl_path=dovecot/auth \
    smtpd_sasl_auth_enable=yes && \
  /opt/editconf.py /etc/postfix/main.cf \
    virtual_mailbox_domains=mysql:/etc/postfix/virtual-mailbox-domains.cf \
    virtual_mailbox_maps=mysql:/etc/postfix/virtual-mailbox-maps.cf \
    virtual_alias_maps=mysql:/etc/postfix/virtual-alias-maps.cf \ 
    local_recipient_maps=\$virtual_mailbox_maps && \
  /opt/editconf.py /etc/postfix/main.cf \
    mynetworks="127.0.0.0/8 172.17.42.0/24" && \
  /opt/editconf.py /etc/opendmarc.conf -s \
    "Syslog=true" \
    "Socket=inet:8893@[127.0.0.1]" && \
  /opt/editconf.py /etc/postfix/main.cf \
    "smtpd_milters=inet:127.0.0.1:8891 inet:127.0.0.1:8893"\
    non_smtpd_milters=\$smtpd_milters \
    milter_default_action=accept && \
  echo "MinimumKeyBits          1024" >> /etc/opendkim.conf && \
  echo "ExternalIgnoreList      refile:/etc/opendkim/TrustedHosts" >> /etc/opendkim.conf && \
  echo "InternalHosts           refile:/etc/opendkim/TrustedHosts" >> /etc/opendkim.conf && \
  echo "KeyTable                refile:/etc/opendkim/KeyTable" >> /etc/opendkim.conf && \
  echo "SigningTable            refile:/etc/opendkim/SigningTable" >> /etc/opendkim.conf && \
  echo "Socket                  inet:8891@localhost" >> /etc/opendkim.conf && \
  echo "RequireSafeKeys         false" >> /etc/opendkim.conf

#RUN /opt/editconf.py /etc/postfix/main.cf \
#smtp_tls_security_level=dane \
#smtp_dns_support_level=dnssec

VOLUME ["/var/spool/postfix/"]

CMD /install.sh;/usr/bin/supervisord -c /etc/supervisor/supervisord.conf

