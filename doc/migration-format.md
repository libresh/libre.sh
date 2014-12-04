# IndieHosters migration format

## Version 0.2.2

When a user exports their data for domain.com, they get a zip or tar file that contains different files, depending on which application is
running on their domain:

### If using the 'static' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* static/www-content - static content to be placed in the web root

### If using the 'static-git' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* static-git/GITURL - git url to pull the static website content from

### If using the 'WordPress' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* mysql/dump.sql - the dump of all their MySQL databases
* mysql/.env - contains the MySQL password
* wordpress/.env - contains the MySQL password
* wordpress/login.txt - username and password for the WordPress admin panel
* wordpress/.htaccess - htaccess file for WordPress
* wordpress/wp-content - php files to be placed in the web root

### If using the 'Known' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* mysql/dump.sql - the dump of all their MySQL databases
* mysql/.env - contains the MySQL password
* known/ - php files to be placed in the web root
* known/.env - contains the MySQL password
* known/login.txt - email address and password for the Known admin panel


# Version 0.3 (proposed, not implemented yet)

### General

An IndieHosters migration archive is a directory structure (probably packaged up as a tar file or zip file).
There should be a 'runme.sh' file in the root of the archive.


### Single-tennant usage

When executing `./runme.sh` from the folder on an empty server that supports Docker, a single-tennant server should be started.


### Multi-tennant postfix-forwarder support

When executing it on a server that is already running an instance of indiehosters/postfix-forwarder:0.3 on port 25 of the host system,
any email forwarding rules for this domain should be added to the existing postfix-forwarder instance.


### Multi-tennant haproxy support

When executing it on a server that is already running an instance of indiehosters/haproxy:0.3 on ports 80 and 443 of the host system,
the web app (if any) should be added as a backend to the existing haproxy instance.
