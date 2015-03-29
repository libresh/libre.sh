FROM indiepaas/apache

# Download latest version of Wordpress into /app
RUN curl -L https://wordpress.org/latest.tar.gz | tar xz && \
  mv wordpress/* app && \
  mv /app/wp-content /wp-content && \
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp
ADD wp-config.php /app/wp-config.php

# Add script to create 'wordpress' DB
ADD run-wordpress.sh /run-wordpress.sh
RUN chmod 755 /run-wordpress.sh

# Expose environment variables
ENV DB_HOST **LinkMe**
ENV DB_PORT **LinkMe**
ENV DB_NAME wordpress
ENV DB_USER admin
ENV DB_PASS **ChangeMe**

EXPOSE 80
VOLUME ["/app/wp-content", "/app/.htaccess"]
CMD ["/run-wordpress.sh"]

