FROM indiepaas/base-email

RUN apt-get update && \
    apt-get install -q -y \
      dovecot-core \
      dovecot-imapd \
      dovecot-lmtpd \
      dovecot-mysql && \
    rm -rf /var/lib/apt/lists/*

COPY 99-local-lmtp.conf /etc/dovecot/conf.d/99-local-lmtp.conf
COPY auth-sql.conf.ext /etc/dovecot/conf.d/auth-sql.conf.ext
COPY dovecot-sql.conf.ext /etc/dovecot/dovecot-sql.conf.ext 
COPY 99-local-auth.conf /etc/dovecot/conf.d/99-local-auth.conf
COPY init.sql /init.sql
COPY startup.sh /startup.sh

RUN \
  groupadd -r postfix && \
  useradd -r -g postfix postfix && \
  chmod u+x /startup.sh && \
  /opt/editconf.py /etc/dovecot/conf.d/10-master.conf \
    default_process_limit=250 && \
  /opt/editconf.py /etc/sysctl.conf \
    fs.inotify.max_user_instances=1024 && \
  /opt/editconf.py /etc/dovecot/conf.d/10-mail.conf \
    mail_location=maildir:/mail/mailboxes/%d/%n \
    mail_privileged_group=mail \
    first_valid_uid=0 && \
  /opt/editconf.py /etc/dovecot/conf.d/10-auth.conf \
    disable_plaintext_auth=yes \
    'auth_mechanisms=plain login' && \
  /opt/editconf.py /etc/dovecot/conf.d/10-ssl.conf \
    ssl=required \
    'ssl_cert=</ssl/ssl_certificate.pem' \
    'ssl_key=</ssl/ssl_private_key.pem' \
    'ssl_protocols=!SSLv3 !SSLv2' \
    'ssl_cipher_list=TLSv1+HIGH !SSLv2 !RC4 !aNULL !eNULL !3DES @STRENGTH' && \
  /opt/editconf.py /etc/dovecot/conf.d/20-imap.conf \
    imap_idle_notify_interval="4 mins" && \
  sed -i "s/#port = 143/port = 0/" /etc/dovecot/conf.d/10-master.conf && \
  sed -i "s/#port = 110/port = 0/" /etc/dovecot/conf.d/10-master.conf && \
  sed -i "s/#*\(\!include auth-system.conf.ext\)/#\1/"  /etc/dovecot/conf.d/10-auth.conf && \
  sed -i "s/#\(\!include auth-sql.conf.ext\)/\1/"  /etc/dovecot/conf.d/10-auth.conf && \
  mkdir -p /mail/mailboxes && \
  chown -R mail:dovecot /etc/dovecot && \
  chown -R mail.mail /mail/mailboxes && \
  chmod -R o-rwx /etc/dovecot && \
  chmod 0600 /etc/dovecot/dovecot-sql.conf.ext

ENTRYPOINT ["/startup.sh"]

VOLUME ["/var/spool/postfix/dovecot"]

EXPOSE 993

