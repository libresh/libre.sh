# Migration procedure version 0.3

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

Migration procedures:

* [Domain name registration](../proc/dnr.md)
* [DNS hosting](../proc/dns.md)
* [Email forwarding](../proc/email.md)
* [TLS certificate](../proc/tls.md)
* [Web application](../proc/webapp.md)
