# Migration procedure version 0.3

## Introduction

The IndieHosters network aims to allow users to easily migrate their hosted services from one hosting provider to another.
To this goal, we describe a number of services which a hosting provider may offer, and a migration procedure for each of these.
In this document, we will say the "user" migrates "services" from the "old hoster" to the "new hoster".

We distinguish two types of migration: full migrations, and partial migrations. A full migration includes the migration of
the domain name registration, DNS hosting, and all other hosted applications from the old hoster to the new hoster, and the user
will no longer be a customer of old hoster once the full migration is complete.

In a partial migration, only some services are migrated, and others are not. For instance, the IndieHosters product "Known hosting 0.3"
consists of:

* a domain name registration at a well-known registrar
* DNS hosting
* email forwarding
* a redirect from http to https on port 80
* a TLS certificate on port 443
* version 0.6.5-mysql of the Known application running behind that

If the old hoster offers this product, but the new hoster does not offer email forwarding, then only a partial migration is
possible. The user will then have to accept that their email forwarding will stop working. Presumably, the user is OK with
that, since they picked the new hoster themselves. But it's worth mentioning that this is then only a partial migration.

## Basic hosting services

### Domain name registration

How to migrate a domain name from one hosting provider to another depends on the extension, and even for a given extension, there
are serveral possibilities. In version 0.3 of this migration procedure, we will only consider one basic case, which is quite easy
to deal with:

* the user either is the registrant or represents the registrant
* the user is the admin contact and the billing contact
* the old hoster is the technical contact
* the domain name registration is in account at a well-known registrar (e.g. NameCheap)
* this registrar account is under control of the old hoster (not of the user directly)
* the new hoster also has an account at this well-known registrar, or is willing to create one
* the registrar offers a "Transfer to another account" option

The migration process is then as follows:

* user has a service of type "domain name registration" with old hoster. Registrant is well-known and all above points apply
* old hoster is listed in the IndieHosters migration network as supporting emigrations with type 'domain name registration'
* new hoster is listed in the IndieHosters migration network as supporting immigrations with
  * type: 'domain name registration'
  * registrar: 'NameCheap' (or whichever well-known registrar)
* user contacts old hoster, stating clearly and unmistakably that they want to migrate to new hoster
* old hoster contacts new hoster to:
  * confirm they will accept the migration
  * agree on compensation for registration fee for months left until the domain is up for renewal at registrar
  * agree on possible transfer of user's prepaid credit, e.g. if they were paying yearly at old hoster
  * double check the new hoster's account identifier at the well-known registrar
* old hoster transfers the domain name registration into the new hoster's account at the well-known registrar
* old hoster notifies new hoster and user that this has been done

### DNS hosting

The migration of DNS hosting will usually result automatically when transferring a domain name registration and/or other hosted
services. However, if the user had custom DNS records, then these may be transferred as a text file.

### Email forwarding

The old hoster tells the new hoster what the user's forwarding address is.

### TLS certificate

The old hoster sends the certificate to the new hoster one or more .pem files, where the .pem file containing the private key is
encrypted with a passphrase.

The old hoster sends the passphrase over a secure medium, in an unrelated message. For instance, if the .pem files were sent via
scp, the passphrase may be sent via PGP-encrypted email.

### Web application (simplistic procedure)

* The old hoster puts the site in read-only mode by changing the permissions of the database user to read-only
* The old hoster creates the migration archive as per the [IndieHosters migration format](migration-format.md)
* The old hoster sends the migration archive to the new hoster
* The new hoster imports the migration archive
* Once DNR, DNS, and TLS have also been migrated, the old hoster terminates the service.

### Web application (advanced procedure)

* The TLS certificate is sent ahead first
* The old hoster programmatically creates the migration archive, and immediately *posts* it to the new hoster via a webhook
* The webhook programmatically imports the migration archive, and returns the IP address
* The old hoster programmatically configures the new hoster's public IP address into their load balancer
* The old hoster's load balancer now forwards (at the TCP level) all traffic to this new IP address
* Once DNR and DNS transfer are complete, the old hoster terminates the TCP forwarding service.


