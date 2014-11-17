# Adding an application

There are two types of application: server-wide, and per-user. Right now, server-wide applications are the postfix-forwarder,
and the haproxy. Available per-user applications right now are wordpress, static, and static-git.

# Adding a server-wide application

To add a server-wide application, first make sure it can run on one IPv4 address for multiple domains. If it can, then:

* Package it into one Dockerfile per process, and add these to the [dockerfiles](https://github.com/indiehosters/dockerfiles) repo.
* Add `docker pull`, `systemctl enable` and `systemctl start` commands to `scripts/setup.sh`.
* Make it take user data from /data/PROCESS/, and data that is needed at runtime but should not be backed up can
go into /data/runtime/PROCESS
* Create a systemd unit file for each process in the `unit-files/` folder
* Either add functionality to `scripts/add-site.sh` to configure domains on this new service, or describe the manual steps for this
in [deploying-a-server.md](deploying-a-server.md).
* Double-check all documentation to see if it is all still correct.

# Adding a per-user application

To add a per-user application, first make sure it can run behind an SNI offloader. For instance, for WordPress to work behind an SNI
offloader, we had to activate the "https" plugin. If it can, then:

* First study how for instance the WordPress application works in this repo, the easiest approach is to copy it as a starting point.
* Package it into one Dockerfile per process, and add these to the [dockerfiles](https://github.com/indiehosters/dockerfiles) repo.
* Add `docker pull` commands to `scripts/setup.sh`.
* Make it take user data from /data/domains/DOMAIN.COM/PROCESS/, and data that is needed at runtime but should not be backed up can
go into /data/runtime/domains/DOMAIN.COM/PROCESS.
* Create a systemd unit file for each process in the `unit-files/` folder, ending in "@.service", so they get symlinked for each domain.
* If there are cronjobs to be added, then this is done with "@.timer" files.
* Link the processes together, using docker linking and systemd dependencies.
* Add import logic, and if there is any pre-backup action necessary to make sure all relevant data is under /data/domain, then add this as
a pre-step to the backup unit.
* Either add functionality to `scripts/add-site.sh` to configure domains on this new service, or describe the manual steps for this
in [deploying-a-server.md](deploying-a-server.md).
* Double-check all documentation to see if it is all still correct.
