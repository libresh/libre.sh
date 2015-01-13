domains=( domain1 domain2 )

# START
for domain in "${domains[@]}"
do
  cp -R /data/runtime/domains/$domain/static-git /data/domains/$domain/static
  systemctl stop static-git@$domain
  systemctl start static@$domain
  systemctl list-units | grep $domain | grep failed
done
# STOP

# ROLLBACK START
for domain in "${domains[@]}"
do
  systemctl stop static@$domain
  systemctl start static-git@$domain
done
# ROLLBACK STOP

# CLEAN START
for domain in "${domains[@]}"
do
  systemctl disable static-git@$domain
  systemctl enable static@$domain
  rm -rf /data/domains/$domain/static-git
done
# CLEAN STOP
