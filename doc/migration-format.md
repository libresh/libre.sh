# IndieHosters migration format, version 0.2.1

When a user exports their data for domain.com, they get a zip or tar file that contains different files, depending on which application is
running on their domain:

## If using the 'static' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* static/www-content - static content to be placed in the web root

## If using the 'static-git' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* static-git/GITURL - git url to pull the static website content from

## If using the 'WordPress' application

* TLS/domain.com.pem - Concatenation of the unencrypted private and public key of the TLS certificate, and intermediate CA cert if applicable.
* mysql/dump.sql - the dump of all their MySQL databases
* mysql/.env - contains the MySQL password
* wordpress/.env - contains the MySQL password
* wordpress/login.txt - username and password for the WordPress admin panel
* wordpress/.htaccess - htaccess file for WordPress
* wordpress/wp-content - php files to be placed in the web root
