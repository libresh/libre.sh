# 1.0.0

* libre command
* post-update scripts
* SUBNET support (allow more than 32 applications per server)
* usage of .env file

# 0.3.0

* adds automation script for user provisionning
* moves backup to duplicity
* big simplification
* some fixes

# 0.2.4

* improve tests
* wordpess version 4.1
* Internal modifications
  * rename project
  * rename images
  * integrate dockerfiles to the project
  * add hotfixes

# 0.2.3

* fixes backup
* better tests
* import dump.sql when relevant

# 0.2.2

* add Known as an application

# 0.2.1

* draft instructions for how to add an application (whether server-wide or per-user)
* several bugfixes

# 0.2.0

* a separation between /data/domains and /data/runtime, making site immigration much easier
* the wordpress image and the mysql image it depends on
* the backup service which commits all user content, including a mysql dump, to a private git repo, and pushes that out to a remote destination every hour
* the nginx image from 0.1.0 split into static and static-git


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
