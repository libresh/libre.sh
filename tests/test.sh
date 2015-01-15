#!/bin/bash -eux

cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload

image=$1

# prepare data
folder=/data/domains/$image.test
mkdir -p ${folder}/TLS
cp /data/indiehosters/scripts/unsecure-certs/example.dev.pem ${folder}/TLS/$image.test.pem

echo "EMAIL=test@test.org" > ${folder}/.env

case "$image" in
"static" )
  echo "APPLICATION=nginx" >> ${folder}/.env
  echo 'DOCKER_ARGUMENTS="-v /data/domains/static.test/static/www-content:/app"' >> ${folder}/.env
  ;;
"wordpress" )
  echo "APPLICATION=$image" >> ${folder}/.env
  echo 'DOCKER_ARGUMENTS="--link mysql-wordpress.test:db \
  -v /data/domains/wordpress.test/wordpress/data:/app/wp-content \
  -v /data/domains/wordpress.test/wordpress/.htaccess:/app/.htaccess \
  --env-file /data/domains/wordpress.test/wordpress/.env"' >> ${folder}/.env
  ;;
"known" )
  echo "APPLICATION=$image" >> ${folder}/.env
  echo 'DOCKER_ARGUMENTS="--link mysql-known.test:db \
  -v /data/domains/known.test/known/data:/app/Uploads \
  -v /data/domains/known.test/known/.htaccess:/app/.htaccess \
  --env-file /data/domains/known.test/known/.env"' >> ${folder}/.env
  ;;
esac

if [ "$image" == "static" ]; then
  systemctl start $image@$image.test
  systemctl enable $image@$image.test
else
  systemctl start lamp@$image.test
  systemctl enable lamp@$image.test
fi
sleep 20

systemctl list-units | grep "$image\.test" | grep -c failed | grep 0
ip=`docker inspect --format {{.NetworkSettings.IPAddress}} $image.test`
curl -L $ip

