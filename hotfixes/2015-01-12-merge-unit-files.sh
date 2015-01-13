domains=( domain1 domain2 )

# START
echo "APPLICATION=wordpress"   > /tmp/wordpress_env
echo "VOLUME=/app/wp-content" >> /tmp/wordpress_env
echo "EMAIL=test@test.org"    >> /tmp/wordpress_env
docker pull ibuildthecloud/systemd-docker

for domain in "${domains[@]}"
do
  cp /tmp/wordpress_env /data/domains/$domain/.env
  systemctl stop wordpress@$domain
  systemctl disable wordpress@$domain
  mv /data/domains/$domain/wordpress/wp-content /data/domains/$domain/wordpress/data
done

cd /data/indiehosters
git pull
cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload
docker pull pierreozoux/wordpress

for domain in "${domains[@]}"
do
  systemctl start lamp@$domain
  systemctl enable lamp@$domain
done

docker pull pierreozoux/known

# put the right email in each folder

# STOP

# ROLLBACK START
cd /data/indiehosters
git checkout 2c71084d502c05be220dd2de00acfd0c333bc7ff
cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload
cd dockerfiles/services/wordpress/
docker build -t pierreozoux/wordpress .

for domain in "${domains[@]}"
do
  mv /data/domains/$domain/wordpress/data /data/domains/$domain/wordpress/wp-content
  systemctl start wordpress@$domain
  systemctl enable wordpress@$domain
done
# ROLLBACK STOP

# CLEAN START
rm /etc/systemd/system/static-*
rm /etc/systemd/system/wordpress*
rm /etc/systemd/system/known*
rm /etc/systemd/system/mysql-importer@.service
# CLEAN STOP
