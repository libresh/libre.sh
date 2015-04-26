docker pull indiepaas/wordpress

cd /data/domains
for domain in `ls .`
do
  if cat $domain/.env|grep APPLICATION=wordpress
  then
    systemctl restart web@$domain
    /opt/bin/docker-enter $domain wp --allow-root core update-db --path=/app
  fi
done
