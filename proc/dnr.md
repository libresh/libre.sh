# Migration procedure version 0.3

## Domain name registration

How to migrate a domain name from one hosting provider to another depends on the extension, and even for a given extension, there
are serveral possibilities. In version 0.3 of this migration procedure, we will only consider one basic case, which is quite easy
to deal with:

* the domain name registration is in an account at a well-known registrar (e.g. NameCheap)
* this registrar account is under control of the old hoster (not of the user directly)
* the new hoster also has an account at this same well-known registrar, or is willing to create one
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
* old hoster notifies new hoster and user that this has been done, to reconfirm to the user what the next upcoming renewal date
is for the domain name registration, and if any account credit was transferred
