# LibrePaaS

## Introduction

A PaaS that is aimed at hosting free software \o/

To install it, follow instructions in `INSTALL.nd`.

## Modular

The PaaS is really modular, that's why it contains the strict necessary, then you'll probably want to add `system` modules or `applications`.

## System modules

Here is a list of modules supported:
 - haproxy
 - git-puller
 - backups
Go to their respective page for more details.

To install and start a module:

```
git clone module /system/
systemctl enable s@module
systemctl start s@module
```

## Application modules

To install application `wordpress` on `example.org`, just run:

```
provision -a github.com/indiehosters/wordpress -u example.org -s
```

Run `provision` for more details on the capabilities of the script.

## Contributing

If you have any issue (something not working, mail marked as spam, missing doc), please do report an issue here! Thanks

This system is used in production at [IndieHosters](https://indiehosters.net/) so it is maintained. If you use it, please tell us, and we'll be really happy to update this README!

You can help us by:
 - starring this project
 - sending us a thanks email
 - reporting bugs
 - writing documentation/blog on how you got up and running in 5mins
 - writing more documentation
 - sending us cake :) We loove cake!
