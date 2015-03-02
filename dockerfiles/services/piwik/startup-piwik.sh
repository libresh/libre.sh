#!/bin/bash -eux

source /etc/environment

echo ">> adding softlink from /piwik to /"
rm -rf /usr/share/nginx/html
ln -s /piwik /usr/share/nginx/html
mkdir /usr/share/nginx/html/tmp

chown -R www-data:www-data /usr/share/nginx/html/
chmod -R 755 /usr/share/nginx/html/tmp

if [ -z ${DB_PASS+x} ] || [ -z ${DB_USER+x} ]
then
  echo ">> piwik started, initial setup needs to be done in browser!"
  echo ">> be fast! - anyone with access to your server can configure it!"
  exit 0
fi

echo 
echo ">> #####################"
echo ">> init piwik"
echo ">> #####################"
echo

nginx 2> /tmp/nginx.log > /tmp/nginx.log &

/opt/mysql-check.sh

if [ `echo "SHOW TABLES FROM $DB_NAME;" | mysql -h $DB_HOST -P $DB_PORT -u $DB_USER -p$DB_PASS | grep "piwik_" | wc -l` -lt 1 ]
then
  echo ">> no DB installed, MYSQL User or Password specified - seems like the first start"
  
  #cat /config.ini.php | sed "s/PIWIK_MYSQL_PORT/$DB_PORT/g" | sed "s/PIWIK_MYSQL_USER/$DB_USER/g" | sed "s/PIWIK_MYSQL_PASSWORD/$DB_PASS/g" | sed "s/PIWIK_MYSQL_DBNAME/$DB_NAME/g" > /piwik/config/config.ini.php
  
  cp -R /piwik-config/* /piwik/config/
  chown -R www-data:www-data /usr/share/nginx/html/

  echo ">> init Piwik"
  if [ -z ${EMAIL+x} ]
  then
    PIWIK_ADMIN="admin"
    echo ">> piwik admin user: $EMAIL"
  fi
  
  if [ -z ${PIWIK_ADMIN_PASSWORD+x} ]
  then
    PIWIK_ADMIN_PASSWORD=`perl -e 'my @chars = ("A".."Z", "a".."z"); my $string; $string .= $chars[rand @chars] for 1..10; print $string;'`
    echo ">> generated piwik admin password: $PIWIK_ADMIN_PASSWORD"
  fi
  
  if [ -z ${PIWIK_SUBSCRIBE_NEWSLETTER+x} ]
  then
    PIWIK_SUBSCRIBE_NEWSLETTER=0
  fi
  
  if [ -z ${PIWIK_SUBSCRIBE_PRO_NEWSLETTER+x} ]
  then
    PIWIK_SUBSCRIBE_PRO_NEWSLETTER=0
  fi
  
  if [ -z ${EMAIL+x} ]
  then
    EMAIL="no@no.tld"
    PIWIK_SUBSCRIBE_NEWSLETTER=0
    PIWIK_SUBSCRIBE_PRO_NEWSLETTER=0
  fi

  if [ -z ${SITE_NAME+x} ]
  then
    SITE_NAME="My local Website"
  fi
  
  if [ -z ${SITE_URL+x} ]
  then
    PRIMARY_DOMAIN=`echo $URL | cut -d. -f2,3`
    SITE_URL="http://${PRIMARY_DOMAIN}"
  fi
  
  if [ -z ${SITE_TIMEZONE+x} ]
  then
    SITE_TIMEZONE="Europe/Paris"
  fi
  
  if [ -z ${SITE_ECOMMERCE+x} ]
  then
    SITE_ECOMMERCE=0
  fi

  if [ -z ${ANONYMISE_IP+x} ]
  then
    ANONYMISE_IP=1
  fi
  
  if [ -z ${DO_NOT_TRACK+x} ]
  then
    DO_NOT_TRACK=1
  fi

  echo ">> piwik wizard: #1 open installer"
 
  curl "http://${URL}/" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #2 open system check"

  curl "http://${URL}/index.php?action=systemCheck&trackerStatus=0" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #3 open database settings"

  curl "http://${URL}/index.php?action=databaseSetup&trackerStatus=0" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=systemCheck&trackerStatus=0' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #4 store database settings"

  curl "http://${URL}/index.php?action=databaseSetup&trackerStatus=0" \
  -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Origin: http://${URL}/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://${URL}/index.php?action=databaseSetup&trackerStatus=0' -H 'Connection: keep-alive' --compressed \
  --data-urlencode host="$DB_HOST:$DB_PORT" \
  --data-urlencode username="$DB_USER" \
  --data-urlencode password="$DB_PASS" \
  --data-urlencode dbname="$DB_NAME" \
  --data-urlencode tables_prefix="piwik_" \
  --data 'adapter=PDO%5CMYSQL&submit=Next+%C2%BB' \
  2> /dev/null

  curl "http://${URL}/index.php?action=tablesCreation&trackerStatus=0&module=Installation" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=databaseSetup&trackerStatus=0' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #5 open piwik settings"

  curl "http://${URL}/index.php?action=setupSuperUser&trackerStatus=0&module=Installation" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=tablesCreation&trackerStatus=0&module=Installation' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #6 store piwik settings"

  curl "http://${URL}/index.php?action=setupSuperUser&trackerStatus=0&module=Installation" \
  -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Origin: http://${URL}' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://${URL}/index.php?action=setupSuperUser&trackerStatus=0&module=Installation' -H 'Connection: keep-alive' --compressed \
  --data-urlencode login="$EMAIL" \
  --data-urlencode password="$PIWIK_ADMIN_PASSWORD" \
  --data-urlencode password_bis="$PIWIK_ADMIN_PASSWORD" \
  --data-urlencode email="$EMAIL" \
  --data-urlencode subscribe_newsletter_piwikorg="$PIWIK_SUBSCRIBE_NEWSLETTER" \
  --data-urlencode subscribe_newsletter_piwikpro="$PIWIK_SUBSCRIBE_PRO_NEWSLETTER" \
  --data 'submit=Next+%C2%BB' \
  2> /dev/null

  curl "http://${URL}/index.php?action=firstWebsiteSetup&trackerStatus=0&module=Installation" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=setupSuperUser&trackerStatus=0&module=Installation' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #7 store piwik site settings"

  curl "http://${URL}/index.php?action=firstWebsiteSetup&trackerStatus=0&module=Installation" \
  -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Origin: http://${URL}' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://${URL}/index.php?action=firstWebsiteSetup&trackerStatus=0&module=Installation' -H 'Connection: keep-alive' --compressed \
  --data-urlencode siteName="$SITE_NAME" \
  --data-urlencode url="$SITE_URL" \
  --data-urlencode timezone="$SITE_TIMEZONE" \
  --data-urlencode ecommerce="$SITE_ECOMMERCE" \
  --data 'submit=Next+%C2%BB' \
  2> /dev/null

  curl "http://${URL}/index.php?action=trackingCode&trackerStatus=0&module=Installation&site_idSite=1&site_name=default" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=firstWebsiteSetup&trackerStatus=0&module=Installation' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5
  
  echo ">> piwik wizard: #8 skip js page"

  curl "http://${URL}/index.php?action=finished&trackerStatus=0&module=Installation&site_idSite=1&site_name=default" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=trackingCode&trackerStatus=0&module=Installation&site_idSite=1&site_name=justabot' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' --compressed \
  2> /dev/null | grep " % Done"

  sleep 5

  echo ">> piwik wizard: #9 final settings"

  curl "http://${URL}/index.php?action=finished&trackerStatus=0&module=Installation&site_idSite=1&site_name=default" \
  -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Origin: http://${URL}/' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Cache-Control: max-age=0' -H 'Referer: http://${URL}/index.php?action=finished&trackerStatus=0&module=Installation&site_idSite=1&site_name=justabot' -H 'Connection: keep-alive' --compressed \
  --data-urlencode do_not_track="$DO_NOT_TRACK" \
  --data-urlencode anonymise_ip="$ANONYMISE_IP" \
  --data 'submit=Continue+to+Piwik+%C2%BB' \
  2> /dev/null

  curl "http://${URL}/index.php" \
  -H 'Accept-Encoding: gzip, deflate, sdch' -H 'Accept-Language: en-US,en;q=0.8,de;q=0.6' -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8' -H 'Referer: http://${URL}/index.php?action=finished&trackerStatus=0&module=Installation&site_idSite=1&site_name=justabot' -H 'Cookie: pma_lang=en; pma_collation_connection=utf8_general_ci; pma_mcrypt_iv=n%2Bxpbn2a%2Btg%3D; pmaUser-1=L60fYDVIaz0%3D' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' --compressed \
  2> /dev/null

  sleep 5
  
fi

echo ">> update CorePlugins"
curl "http://${URL}/index.php?updateCorePlugins=1" \
  2> /dev/null

sleep 2
  
killall nginx

cat <<EOF
Add the following JS-Code to your Site -> don't forget to change the URLs ;)

<!-- Piwik -->
<script type="text/javascript">
  var _paq = _paq || [];
  _paq.push(['trackPageView']);
  _paq.push(['enableLinkTracking']);
  (function() {
    var u="//!!!YOUR-URL!!!/";
    _paq.push(['setTrackerUrl', u+'piwik.php']);
    _paq.push(['setSiteId', 1]);
    var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
    g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
  })();
</script>
<noscript><p><img src="//!!!YOUR-URL!!!/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript>
<!-- End Piwik Code -->
EOF

