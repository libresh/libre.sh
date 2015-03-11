## IndieHosters

This repository contains the configuration and scripts I use to control my servers.

### Tests

There is a script that provision 2 VMs on Vutlr for tests purpose.

#### Prerequisites

 - have a [vultr account](http://www.vultr.com/?ref=6810586)
 - have a [VULTR API KEY](https://my.vultr.com/settings/)
 - have the [port 25 open](https://www.vultr.com/docs/what-ports-are-blocked) (if you want to test emails)
 - have an [ssh key registered](https://my.vultr.com/sshkeys/)

#### Start tests

/!\ This is still in dev, use it at your own risk /!\

```
export VULTR_API_KEY=
./scripts/start.sh
ssh root@server.test
cd /data/indiehosters
./tests/start.sh
./tests/email.sh
reboot
ssh root@server.test
./tests/stop.sh
# find out WordPress password:
journalctl -u web@*.test | grep to\ connect\ test
# find out piwik and owncloud password:
journalctl -u web@*.test | grep \'\>\>\ generated
exit
./scripts/stop.sh
```

Most of the tests are "visual", but by reading them, it gives you an idea on how to start and stop services.

Before running `./scripts/stop.sh`, you can use your browser to see the applications:

* https://wordpress.test/ user: test@test.org pass: as found with journalctl before
* https://owncloud.test/ user: test@test.org pass: as found with journalctl before
* https://piwik.test/ user: test@test.org pass: as found with journalctl before
* https://static.test/ (you will simply see the contents of server.test:/data/domains/static.test/static/www-content/index.html)
* https://known.test/ (you will be able to create a user there)

This is still work in progress, please feel free to contribute to it!

