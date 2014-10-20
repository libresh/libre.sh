Getting started as an IndieHosters hoster
===========

# Prerequisites

Each IndieHoster is an entirely autonomous operator, without any infrastructural ties to other IndieHosters.
These scripts and docs will help you run and manage servers and services as an IndieHoster, whether you're
certified as a branch of the IndieHosters franchise or not.

# Hoster data

If you're used to working with git as a versioning tool, then it's a good idea to make `hoster-data` and
`billing` into (private!) git repos where you keep track of what you're doing, including e.g. TLS certificates, so
that you can track changes over time, and search the history to resolve mysteries when they occur. You may also use a different
versioning system, or just take weekly and daily backups (but then it's probably a good idea to retain the weeklies for a couple
of years, and even then it will not be as complete as a history in a versioning system).

The hoster-data is about what each one of your servers *should* be doing at this moment.
This is fed into CoreOS (systemd -> etcd -> confd -> docker) to make sure the server actually starts and keeps doing these things,
and also into monitoring, to make sure you get alerted when a server misbehaves.

You probably also want to keep track of Domain Name Registration, Transport
Layer Security, Monitoring, and Domain Name System services which you are probably getting from
third-party service providers, alongside the services which
you run on your own servers.
Note that although it's probably inevitable that you resell DNR and TLS services from some third party, and your monitoring would ideally
also run on a system that's decoupled from your actual servers, you may not be reselling DNS
hosting. If you host DNS for your customer on server-wide bind services that directly read data from files on the per-user data folders,
then DNS data will be considered user-data for you.

# User data
User data is data owned by one of your users. Which human owns which site is something you can administer
by hand somehow in the `billing` folder.
All user data is *untrusted* from your point of view, it is not owned by you as a hoster,
and users may change it at any time (and then probably contact you for a backup whenever they mess up!). It makes sense to give users
only read-only access to this data by default, and have a big "Are you sure? Warranty will be void!" warning before they can activate
write-access to their own data (and then probably trigger an extra backup run just before allowing them to edit their own raw data).
This is how some operating systems on user devices also deal with this.
But in the end, the user, and not you, owns this data, and they can do with it what they want, at their own risk.

Just like a mailman is not supposed to open and read letters, you also should treat each user's data as a closed envelope
which you never open up, unless in the following cases:

* There may be things you need to import from specific files on there (like a user-supplied TLS certificate or DNS zone)
* When running backups, you sometimes can't avoid seeing some of the modified filenames flying by (depending on the backup software)
* After explicit permission of the user, when this is useful for tech support (e.g. fix a corrupt mysql database for them)

In version 0.1 no user data exists because the TLS cert is part of the hoster-data, and so are the secondary email address to forward
to and the git repository to pull the website content from. We don't need to back up users' websites, because they are already versioned
and backed up in the git repository from which we're pulling it in.

# Backups
Your user-data, hoster-data, and billing folders together contain all the critical data
of your operations as an IndieHoster, from start to finish, so make sure you don't
ever lose it, no matter what calamity may strike. Once a month, put a copy of it on a USB stick, and put that in a physically safe place.

You may give a trusted person an emergency key to your infrastructure, in case you walk under a bus. Think about the risk of data loss and
establish an emergency recovery plan for when, for instance, the hard disk of your laptop or of one of your servers die.

Make sure you often rsync the live data from each of your servers to somewhere else, and store snapshots of it
regularly. Users *will* contact you sooner or later asking for "the backup from last Tuesday"
and they will expect you to have one.

# Basic digital hygiene
At the same time, be careful who may obtain access to your critical data. Is your laptop really safe? Does the NSA have access to the servers you run?

Someone may plant a Trojan on a computer in an internet cafe from where you access your Facebook account, access your gmail account
for which you use the same password, reset your RackSpace password and restore a backup from your Cloud Files to somewhere else.

Make a diagram of how your laptop talks to your USB sticks and your servers. Then make a diagram of the services you use and to which
email addresses they send password reset emails. Draw a perimeter of trust in both diagrams, and start taking some basic measures to
keep your daily operations secure.

Don't mix accounts and email addresses which you may
use from other computers, and keep your IndieHosters passwords and accounts separate from your other passwords and accounts, and reset
them every few months. It might even
make sense to dual-boot your laptop or boot from a live disk which resets on boot to make sure everything you do with IndieHosters data
is done in a sterile environment. Ubuntu has a 'guest account' option on the login screen which maybe also be handy for this.

Also: lock your screen when walking away from your laptop, and think about what someone could do with it if they were to steal your bag,
or your smartphone.

# Do I have to use this?
As an IndieHoster you can of course use any infrastructure and scripts you want, as long as it doesn't change the format of each user-data folder, so that
your customers can still migrate at will between you and other IndieHosters. However, you might find some of the scripts in this repo
helpful at some point, and we hope you contribute any features you add to it back upstream to this repo.
Thanks for taking the time to read through these general considerations - the next topic is [deploying a server](deploying-a-server.md)! :)
