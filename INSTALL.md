# Instructions to install libre.sh

## Recommendation
- you'd need API key on Namecheap (if you want to automatically buy and configure domain name)

## Installation

These instructions depend a bit on your cloud provider.

### [Digital Ocean](https://m.do.co/c/1b468ce0671f)

 1. Install [doctl](https://github.com/digitalocean/doctl/)
 2. Issue the following command:

```
doctl compute droplet create libre.sh --user-data-file ./user_data --wait --ssh-keys $KEY_ID --size 1gb --region lon1 --image coreos-stable
```

### Provider with user_data support

If you use a cloud provider that support `user_data`, like [Scaleway](http://scaleway.com/), just use [this user_data](https://raw.githubusercontent.com/indiehosters/libre.sh/master/user_data).

### Hetzner

You can also buy a baremetal at [Hetzner](https://serverboerse.de/index.php?country=EN) as they are the cheapest options around. Follow these [instructions](INSTALL_HETZNER.md) in this case.

### Provider without user_data support

Use boot a live cd, and issue that command:

```
wget https://raw.github.com/coreos/init/master/bin/coreos-install
bash coreos-install -d /dev/sda -c user_data
```

And voila, your first libre.sh node is ready!
