## Prerequisites to work on this project:
- [vagrant](http://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)
- optional: [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
  - run `vagrant plugin install vagrant-hostsupdater` to install

## Get started:

```bash
vagrant up
```

Wait the provisionning to finish (~40mins), and go to your browser: http://coreos.dev

### If you want to start another wordpress:
```bash
vagrant ssh
sudo systemctl start wordpress@myuser.service
```
Update haproxy configuration in ``/data/server-wide/haproxy/haproxy.cfg`.
Check in your bowser!
