# TL;DR

 - k8s
  - [ ] ceph
  - [ ] flannel
  - [ ] baremetal install

# Object

The aim of this document is to write the big lines of the future of libre.sh.

# Version 1

The current version, let's call it 1, is a nice opiniated framework on how to run a single host with docker-compose.
It provides a list of packages and module compatible with this framework.
The best features of this framework are:
 - https only
 - some integration between the tools (auto provisioning of emails for new applications)
 - domain name buying (Namecheap api)
 - dns configuration (Namecheap api)

# Version 2 - k8s

This roadmap will discuss about the migration to kubernetes (k8s).

## Distributions

There are various k8s distributions (Tectonic, deis, openshift..) and the aim of libre.sh is not to become yet another distribution.

It would be nice if we could list them, evaluate them, and decide to use one of them or not.

## Installation/Operation

libre.sh should be opiniated on the way to install and operate the cluster.

It should provide easy steps to install on baremetal first. We aim for libre software, and as such, we can't rely
on cloud providers like gcloud, aws, or digital ocean.
As a second priority, we should give easy instructions to deploy on any cloud providers, as people are free to choose their chains :)

## Storage

One big challenge in k8s cluster context is to provide an implementation of major cloud providers about [PersistantVolume](https://kubernetes.io/docs/user-guide/persistent-volumes/).
In a libre cluster, this function would be achieved by a distributed file system technology.
After some investigation, the choice would be to use ceph.
There are already some work done on it like the [ceph-docker](https://github.com/ceph/ceph-docker/tree/master/examples) repo.

## Network

Another big challenge is network. k8s is strongly opiniated on what should be the network configuration.
Ideally, we would use some IPsec to secure the links between machine in a context we can't trust the network (like at hetzner).
There are 3 options:
 - zerotier  
 - tinc vpn
 - flannel that might implement IPsec in a near future

The cheapest in term of work would be to bet on flannel.

## Packages

There is now a way to create and distribute packages in a standard way.
We can then remove the idea of modules and applications.
They will all be packages.

The k8s standard for that is [helm](http://helm.sh/). There is already a big list of packages.
As for libre.sh, the idea would be to contribute the missing packages there.

### opportunistic packages

libre.sh would then be, just a repo of documentation on how to install, operate and manage a k8s cluster on baremetal.
There is still a place where we can have a difference.

This idea is called opportunistic package.
This would be a package based on an official one.

Let's take the example of WordPress.
The libre.sh version of WordPress would be based on the official one.
But it will have some mechanisms to discovers services available inside the cluster it is running on.

These services could be:
 - ldap
 - piwik
 - email

So, when you install a new WordPress, it will try to discover opportunistically if there is a ldap service in the cluster,
and if yes, configure WordPress to use this ldap service.

This pattern will help make it happen:
https://github.com/kubernetes-incubator/service-catalog
