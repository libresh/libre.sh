## Prerequisites to work on this project:
- [vagrant](http://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)
- optional: [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
  - run `vagrant plugin install vagrant-hostsupdater` to install

## Get started:
- Put a TLS certificate (self-signed is fine, but make sure you have [public, intermediate, and private all concatenated into one .pem file](https://www.digitalocean.com/community/tutorials/how-to-implement-ssl-termination-with-haproxy-on-ubuntu-14-04)) in /data/per-user/coreos.dev/combined.pem on the host system.
- Test it with `openssl s_server -cert /data/per-user/coreos.dev/combined.pem -www`

```bash
vagrant up
```

Wait for the provisioning to finish (~40mins), and go to your browser: https://coreos.dev

### If you want to add another wordpress instance apart from coreos.dev:
- For e.g. example.dev, put a cert for it in /data/per-user/example.dev/combined.pem on
the host system.
- Test it with `openssl s_server -cert /data/per-user/example.dev/combined.pem -www`

```bash
vagrant ssh
sudo sh /data/infrastructure/scripts/approve-user.sh example.dev wordpress
```
Check https://example.dev in your bowser!

### Cleaning up

To clean up stuff from previous runs of your VM, you can do:

```bash
vagrant ssh
rm -rf /etc/systemd/system/multi-user.wants/*
```
and then restart the VM with `vagrant reload`.
