FROM indiehosters/apache

# Download latest version of Known into /app
RUN mkdir -p ; cd /app ; curl -L http://assets.withknown.com/releases/known-0.6.5.tgz | tar xz
RUN mkdir /uploads
RUN chown www-data:www-data /uploads
RUN cp /app/schemas/mysql/mysql.sql /initial_db.sql
RUN mv /app/htaccess.dist /app/.htaccess

# Add script to create 'known' DB
ADD run-known.sh /run-known.sh
RUN chmod 755 /run-known.sh

# Expose environment variables
ENV DB_HOST **LinkMe**
ENV DB_PORT **LinkMe**
ENV DB_NAME known
ENV DB_USER admin
ENV DB_PASS **ChangeMe**

# to be cleaned up:

EXPOSE 80
VOLUME ["/app"]
CMD ["/run-known.sh"]
