# Migration procedure version 0.3

## Web application (simplistic procedure)

* The old hoster puts the site in read-only mode by changing the permissions of the database user to read-only
* The old hoster creates the migration archive as per the IndieHosters migration format (see below)
* The old hoster sends the migration archive to the new hoster
* The new hoster imports the migration archive
* Once DNR, DNS, and TLS have also been migrated, the old hoster terminates the service.

## Web application (advanced procedure)

* The TLS certificate is sent ahead first
* The old hoster programmatically creates the migration archive, and immediately *posts* it to the new hoster via a webhook
* The webhook programmatically imports the migration archive, and returns the IP address
* The old hoster programmatically configures the new hoster's public IP address into their load balancer
* The old hoster's load balancer now forwards (at the TCP level) all traffic to this new IP address
* Once DNR and DNS transfer are complete, the old hoster terminates the TCP forwarding service.

## IndieHosters migration format, version 0.3

### General

An IndieHosters migration archive is a directory structure (probably packaged up as a tar file or zip file).
There should be an 'indiehosters.json' file in the root of the archive. It should contain at least the following fields:

 * format: the URL of this spec (probably https://indiehosters.net/spec/0.3)
 * application: a string, which determines what the rest of the folder contents should be imported into.


### Known

When migrating a Known application, the 'indiehosters.json' file should furthermore contain the following fields:

  * application: 'known'
  * version: the version of Known as a string, for instance '0.6.5'
  * database:
    * engine: the database engine used, either 'mysql' or 'mongodb'
    * name: the database name inside the dump file, for instance 'known'
    * file: the database dump file inside the archive, for instance 'dump.sql'
  * uploads: the uploads folder name inside the archive, for instance 'uploads/'
  * plugins: the folder with any non-standard plugins for instance 'plugins/'


### WordPress

(to be determined)
