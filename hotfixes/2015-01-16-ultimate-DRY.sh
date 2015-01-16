static_domains=( domain1 domain2 )
wordpress_domains=( domain1 domain2 )

# START
cd /data/indiehosters
git pull
cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload
docker pull pierreozoux/wordpress

for domain in "${static_domains[@]}"
do
  folder=/data/domains/${domain}
  echo "EMAIL=test@test.org" > ${folder}/.env
  echo "APPLICATION=nginx"  >> ${folder}/.env
  echo DOCKER_ARGUMENTS="-v ${folder}/static/www-content:/app" >> ${folder}/.env
  systemctl restart static@$domain
  systemctl status static@$domain
  systemctl status web@$domain
done  

for domain in "${wordpress_domains[@]}"
do
  folder=/data/domains/${domain}
  echo "EMAIL=test@test.org" > ${folder}/.env
  echo "APPLICATION=wordpress"  >> ${folder}/.env
  echo DOCKER_ARGUMENTS="--link mysql-${domain}:db \
-v /data/domains/${domain}/wordpress/data:/app/wp-content \
-v /data/domains/${domain}/wordpress/.htaccess:/app/.htaccess \
--env-file /data/domains/${domain}/wordpress/.env" >> ${folder}/.env
  systemctl restart lamp@$domain
  systemctl status lamp@$domain
  systemctl status web@$domain
done  

# STOP

# ROLLBACK START
cd /data/indiehosters
git checkout 65d6486005e3d96e3ad9d5ab17f99d8910cc5e70 
cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload
cd dockerfiles/services/wordpress/
docker build -t pierreozoux/wordpress .

for domain in "${wordpress_domains[@]}"
do
  systemctl restart lamp@$domain
done
for domain in "${static_domains[@]}"
do
  systemctl restart static@$domain
done
# ROLLBACK STOP

# CLEAN START
# CLEAN STOP
