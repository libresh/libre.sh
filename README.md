## Prerequisites to work on this project:
- [vagrant](http://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)
- optional: [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
  - run `vagrant plugin install vagrant-hostsupdater` to install

## Get started:

```bash
vagrant up
```

Wait for the provisioning to finish (~40mins), and go to your browser: http://coreos.dev

### If you want to add another wordpress instance:
```bash
vagrant ssh
sudo sh /data/infrastructure/scripts/adduser.sh example.dev wordpress
```
Check http://example.dev in your bowser!
