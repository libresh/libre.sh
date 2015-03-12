FROM nginx

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
      mysql-client \
      php5-fpm \
      php5-mysql \
      ssmtp \
      curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/conf.d/* && \
    rm -rf /usr/share/nginx/html/* && \
    mkdir -p /etc/nginx/external && \
    sed -i 's/access_log.*/access_log \/dev\/stdout;/g' /etc/nginx/nginx.conf && \
    sed -i 's/error_log.*/error_log \/dev\/stdout info;/g' /etc/nginx/nginx.conf && \
    sed -i 's/^pid/daemon off;\npid/g' /etc/nginx/nginx.conf && \
    sed -i "s/.*sendmail_path.*/sendmail_path = \/usr\/sbin\/ssmtp -t/g" /etc/php5/fpm/php.ini && \
    sed -i 's/;default_charset.*/default_charset = "UTF-8"/g' /etc/php5/fpm/php.ini && \
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini

ADD basic.conf /etc/nginx/conf.d/basic.conf
ADD entrypoint.sh /opt/entrypoint.sh
RUN chmod u+x /opt/entrypoint.sh

ADD mysql-check.sh /opt/mysql-check.sh
RUN chmod u+x /opt/mysql-check.sh

COPY ssmtp.conf /etc/ssmtp/ssmtp.conf

ADD environment /etc/environment

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["nginx"]

