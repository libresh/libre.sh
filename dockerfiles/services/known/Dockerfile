FROM pierreozoux/apache

# Download latest version of Known into /app
RUN mkdir -p /app && \
  cd /app && \
  curl -L http://assets.withknown.com/releases/known-0.7.1.tgz | tar xz

# Add script to create 'known' DB
ADD run-known.sh /run-known.sh
RUN chmod 755 /run-known.sh

# Expose environment variables
ENV DB_HOST **LinkMe**
ENV DB_PORT **LinkMe**
ENV DB_NAME known
ENV DB_USER admin
ENV DB_PASS **ChangeMe**

EXPOSE 80
VOLUME ["/app/Uploads", "/app/.htaccess"]
CMD ["/run-known.sh"]
