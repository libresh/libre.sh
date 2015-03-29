FROM indiepaas/nginx-php

# install owncloud
RUN echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/Debian_7.0/ /' >> /etc/apt/sources.list.d/owncloud.list && \
    curl -L http://download.opensuse.org/repositories/isv:ownCloud:community/Debian_7.0/Release.key | apt-key add - && \
    apt-get update && apt-get install -y \
      owncloud \
      php5-imap && \
    apt-get install -y --no-install-recommends \
      libreoffice && \
    rm -rf /var/lib/apt/lists/* && \
    php5enmod imap && \
    mv /var/www/owncloud/apps /owncloud-apps && \
    sed -i 's/^post_max_size =.*/post_max_size = 0/g' /etc/php5/fpm/php.ini && \
    sed -i 's/^upload_max_filesize =.*/upload_max_filesize = 25G/g' /etc/php5/fpm/php.ini && \
    sed -i 's/^max_file_uploads =.*/max_file_uploads = 100/g' /etc/php5/fpm/php.ini && \
    sed -i 's/# exec CMD/# exec CMD\n\/opt\/startup-owncloud.sh/g' /opt/entrypoint.sh

# install nginx owncloud config
ADD nginx-owncloud.conf /etc/nginx/conf.d/nginx-owncloud.conf

# add startup.sh
ADD startup-owncloud.sh /opt/startup-owncloud.sh
RUN chmod a+x /opt/startup-owncloud.sh

# Expose environment variables
ENV DB_NAME owncloud
ENV DB_USER admin

