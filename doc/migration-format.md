# IndieHosters migration format

# Version 0.3

### General

An IndieHosters migration archive is a directory structure (probably packaged up as a tar file or zip file).
There should be an 'indiehosters.json' file in the root of the archive. It should contain at least the following fields:

 * format: the URL of this spec (probably https://indiehosters.net/spec/0.3)
 * application: a string, which determines what the rest of the folder contents should be imported into.


## Known

When migrating a Known application, the 'indiehosters.json' file should furthermore contain the following fields:

  * application: 'known'
  * version: the version of Known as a string, for instance '0.6.5'
  * database:
    * engine: the database engine used, either 'mysql' or 'mongodb'
    * name: the database name inside the dump file, for instance 'known'
    * file: the database dump file inside the archive, for instance 'dump.sql'
  * uploads: the uploads folder name inside the archive, for instance 'uploads/'
  * plugins: the folder with any non-standard plugins for instance 'plugins/'


## WordPress

(to be determined)


## Version 0.2.2 (deprecated)

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
