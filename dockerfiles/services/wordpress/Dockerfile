FROM pierreozoux/apache

# Download latest version of Wordpress into /app
RUN curl -L https://wordpress.org/wordpress-4.1.tar.gz | tar xz && \
  mv wordpress/* app
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
