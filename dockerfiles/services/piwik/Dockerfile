FROM indiepaas/nginx-php

RUN apt-get update && apt-get install -y \
      php5-gd \
      php5-geoip \
      php5-cli \
      zip \
      php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl -O "http://builds.piwik.org/piwik.zip" && \
    unzip piwik.zip && \
    mv /piwik/config /piwik-config && \
    sed -i 's/;always_populate_raw_post_data = -1/always_populate_raw_post_data=-1/g' /etc/php5/fpm/php.ini && \
    cd /piwik/misc/ && \
    curl http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz > GeoLiteCity.dat.gz && \
    gunzip GeoLiteCity.dat.gz && \
    mv GeoLiteCity.dat GeoIPCity.dat && \
    sed -i 's/# exec CMD/# exec CMD\n\/opt\/startup-piwik.sh/g' /opt/entrypoint.sh

# install nginx piwik config
ADD nginx-piwik.conf /etc/nginx/conf.d/nginx-piwik.conf

# add startup.sh
ADD startup-piwik.sh /opt/startup-piwik.sh
RUN chmod a+x /opt/startup-piwik.sh

# Expose environment variables
ENV DB_NAME piwik
ENV DB_USER admin

VOLUME "/piwik/config/"

