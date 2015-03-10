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
./scripts/start.sh #need root access to modify your /etc/hosts
ssh root@server.test
cd /data/indiehosters
./tests/start.sh
./tests/email.sh
reboot
ssh root@server.test
./tests/stop.sh
exit
./scripts/stop.sh #need root access to modify your /etc/hosts
```

Most of the tests are "visual", but by reading them, it gives you an idea on how to start and stop services.

This is still work in progress, please feel free to contribute to it!

