## IndieHosters

This repository contains the confd and bash scripts we use to control our servers.
It can run inside Vagrant (see below; FIXME: check whether these instruction currently work) or
[deploy to a server](doc/getting-started-as-a-hoster.md) (FIXME: update those instructions to
prescribe less folder structure, explain static https+smtp hosting, and check if they currently
work).

## Prerequisites to running this code with Vagrant:
- [vagrant](http://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)
- nfs
  - run `apt-get install nfs-kernel-server`, or your OS equivalent
- optional: [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
  - run `vagrant plugin install vagrant-hostsupdater` to install

## Get started:

```bash
vagrant up
```

Wait for the provisioning to finish (~40mins), and go to your browser: https://indiehosters.dev

### FIXME: this is outdated: If you want to add another nginx instance apart from indiehosters.dev:
- For e.g. example.dev, put a cert for it in /data/per-user/example.dev/combined.pem on
the host system.
- Test it with `openssl s_server -cert /data/per-user/example.dev/combined.pem -www`

```bash
vagrant ssh
sudo sh /data/indiehosters/scripts/approve-user.sh example.dev wordpress
```
Check https://example.dev in your bowser!

### Cleaning up

To clean up stuff from previous runs of your VM, you can do:

```bash
vagrant ssh
rm -rf /etc/systemd/system/multi-user.wants/*
```
and then restart the VM with `vagrant reload`.
