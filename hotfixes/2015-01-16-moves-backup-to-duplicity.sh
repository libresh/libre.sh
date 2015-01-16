# START
docker pull pierreozoux/duplicity

gpg --gen-key
gpg --list-keys

echo ENCRYPT_KEY="" >> /etc/environment
echo BACKUP_DESTINATION="backup@backup" >> /etc/environment

cd /data/indiehosters
git pull
cp /data/indiehosters/unit-files/* /etc/systemd/system && sudo systemctl daemon-reload

for domain in "${domains[@]}"
do
  systemctl start backup@$domain
  systemctl status backup@$domain
done

# STOP

# CLEAN START
rm -rf /data/import
rm /data/BACKUP_DESTINATION
su backup
cd
mkdir old_backups
mv ./* old_backups
# CLEAN STOP
