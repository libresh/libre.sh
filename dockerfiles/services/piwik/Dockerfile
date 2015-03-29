FROM indiepaas/nginx-php

RUN apt-get update && apt-get install -y \
      php5-gd \
      php5-geoip \
      php-apc && \
    rm -rf /var/lib/apt/lists/* && \
    curl "http://builds.piwik.org/piwik-latest.tar.gz" | tar xz && \
    mv /piwik/config /piwik-config && \
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

