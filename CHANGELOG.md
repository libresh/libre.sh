# 0.1.0

* Static webhosting
  * based on haproxy with nginx backends
  * all running as Docker containers
  * SNI-capable (multiple https domains on one single IPv4 address)
  * pulls in content from any git repo, then updates every 10 minutes
  * can be run redundantly in round-robin DNS setup

* email forwarder
  * based on postfix
  * stateless apart from simple configuration files
  * can be run redundantly on multiple MX handlers

* automated administration
  * Docker containers are orchestrated with etcd and systemd
  * script to deploy it on a remote coreos server
  * script for adding a site from a git repo
  * script for adding an empty placeholder site
  * docs describing how to use these scripts
  * Vagrantfile for using it inside vagrant
