## IndieHosters

This repository contains the configuration and scripts we use to control our servers.
It can run inside Vagrant or
[deploy to a server](doc/getting-started-as-a-hoster.md) (FIXME: update those instructions to
prescribe less folder structure, explain static https+smtp hosting, and check if they currently
work).

## Prerequisites to running this code with Vagrant:
- [vagrant](http://www.vagrantup.com/)
- [virtualbox](https://www.virtualbox.org/)
- nfs
  - linux: run `apt-get install nfs-kernel-server`, or your OS equivalent
- [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)
  - run `vagrant plugin install vagrant-hostsupdater` to install

## Get started:

```bash
vagrant up
```

Wait for the provisioning to finish (~12mins), and go to your browser: https://indiehosters.dev

If the process fails, for instance due to network problems, you can retry by running `vagrant provision`.

### If you want to add another static instance apart from indiehosters.dev:

```bash
vagrant ssh
sudo mkdir -p /data/import/example.dev/TLS
sudo cp /data/indiehosters/scripts/unsecure-certs/example.dev.pem /data/import/example.dev/TLS
sudo systemctl start static@example.dev
```

Check https://example.dev in your bowser!

### Cleaning up

To clean up stuff from previous runs of your VM, you can do:

```bash
vagrant destroy
vagrant up
```

## Tests

```bash
vagrant destroy
vagrant up
# Check in your browser https://indiehosters.dev
vagrant ssh
sudo su
/data/indiehosters/scripts/tests/main.sh
```
