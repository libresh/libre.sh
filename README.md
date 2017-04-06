# libre.sh

## Introduction

A PaaS that is aimed at hosting free software \o/

## Installation

[![ScreenShot](https://cloud.pierre-o.fr/index.php/apps/files_sharing/ajax/publicpreview.php?x=1364&y=283&a=true&file=preview.png&t=KlxYYFT59GirMJa&scalingup=0)](https://fosdem.org/2017/schedule/event/libre_sh/)

To install it, follow the video above and instructions in `INSTALL.md`.

### What is libre.sh

libre.sh is a little framework to host Docker. It is simple and modular and respect the convention over configuration paradigm.

This is aimed at Hosters to manage a huge amount of different web application, and a quantity of domain names related with emails and so on.

It is currently installed at 3 different hosters in production and hosting ~20 different web applications, with ~500 containers.

Once well installed, in one bash command, you'll be able to:
 - buy a domain name
 - configure DNS for it
 - configure email for it
 - configure dkim for that domain
 - configure dmarc for that domain
 - configure autoconfig for that domain
 - install and start a web application on that domain (WordPress, Nextcloud, piwik...)
 - provision a TLS cert on that domain

Amazing, right?

### Modular

The PaaS is really modular, that's why it contains the strict necessary, then you'll probably want to add `system` modules or `applications`.

It contains 2 [unit-files](https://github.com/indiehosters/LibrePaaS/tree/master/unit-files) to manage system modules and applications, start them at boot, and load the appropriate environment.

### Support

You can use the following channels to request community support:
 - [mailinglist/forum](https://forum.indie.host/t/about-the-libre-sh-category/71)
 - [chat](https://chat.indie.host/channel/libre.sh)

For paid support, just send an inquiry to support@libre.sh.

All of this is hosted by libre.sh :)

## System modules

Here is a list of modules supported:
 - https proxy:
  - [HAProxy](https://github.com/indiehosters/haproxy)
  - [Nginx](https://github.com/indiehosters/nginx)
 - [logs](https://github.com/indiehosters/logs)
 - [monitoring](https://github.com/indiehosters/monitoring)
 - [git-puller](https://github.com/indiehosters/git-puller)
 - [backups](https://github.com/indiehosters/backups)
 - [sshd](https://github.com/indiehosters/sshd)

Go to their respective page for more details.

### To install and start a module:

```
cd /system/
git clone module
cd module
libre enable
libre start
```

## Applications

### Installation

To install application `wordpress` on `example.org`, first make point example.org to your server IP, and then, just run:

```
libre provision -a github.com/indiehosters/wordpress -u example.org -s
```

Run `libre provision` for more details on the capabilities of the script.

## To debug a module or an application:

```
libre ps
libre logs -f --tail=100
libre stop
libre restart
```

## Contributing

If you have any issue (something not working, missing doc), please do report an issue here! Thanks

This system is used in production at [IndieHosters](https://indiehosters.net/) so it is maintained. If you use it, please tell us, and we'll be really happy to update this README!

You can help us by:
 - starring this project
 - sending us a thanks email
 - reporting bugs
 - writing documentation/blog on how you got up and running in 5mins
 - writing more documentation
 - sending us cake :) We loove cake!
