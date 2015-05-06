FROM indiepaas/apache

# Download latest version of Known into /app
RUN mkdir -p /app && \
  cd /app && \
  curl -L http://assets.withknown.com/releases/known-latest.zip -o known.zip && \
  unzip known.zip && \
  rm -rf known.zip && \
  cd IdnoPlugins && \
  curl -L https://github.com/idno/Twitter/archive/master.zip -o twitter.zip && \
  unzip twitter.zip && \
  mv Twitter-master/ Twitter && \
  rm twitter.zip && \
  curl -L https://github.com/idno/Facebook/archive/master.zip -o facebook.zip && \
  unzip facebook.zip && \
  mv Facebook-master/ Facebook && \
  rm facebook.zip && \
  curl -L https://github.com/idno/Markdown/archive/master.zip -o markdown.zip && \
  unzip markdown.zip && \
  mv Markdown-master/ Markdown && \
  rm markdown.zip

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
