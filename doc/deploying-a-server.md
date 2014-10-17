# Deploying a server

## Before you start
Make sure you read [getting started](getting-started-as-a-hoster.md) first and created your `indiehosters` folder structure somewhere
on your laptop.

### Prepare your orchestration data
* Get a CoreOS server, for instance from [RackSpace](rackspace.com) or [Vultr](vultr.com).
* If you didn't add your public ssh key during the order process (e.g. through your IaaS control panel or a cloud-config file), and unless it's already there from a previous server deploy job, copy your laptop's public ssh key (probably in `~/.ssh/id_rsa.pub`) to `indiehosters/orchestration/deploy-keys/authorized_keys`
* Give the new server a name (in this example, we call the server 'k3')
* Create an empty folder `indiehosters/orchestration/per-server/k3/sites` (replace 'k3' with your server's domain name)
* Add k3 to your /etc/hosts with the right IP address
* If you have used this name before, run `./deploy/forget-server-fingerprint.sh k3`
* From the `indiehosters/dev-scripts` folder, run `sh ./deploy/deploy.sh k3`
* This will ask for the ssh password once; the rest should be automatic!

### Adding a website to your server
* For each site you want to deploy on the server, e.g. example.com, do the following:
  * Does example.com already exist as a domain name?
    * If yes, then find out to what extent it's currently in use (and needs to be migrated with care). There are a few options:
      * Transfer the domain into your DNR account.
      * Set up DNS hosting for it and ask the owner to set authoritative DNS to the DNS servers you control
      * Ask the user to keep DNR and DNS control where it is currently, but to switch DNS when it's ready at the new server
      * In any case, you will probably need access to the hostmaster@example.com email address, for the StartSSL process *before*
        the final DNS switch. You could also ask them to tell you the verification code that arrives there, but that has to be done
        in real time, immediately when you click 'verify' in the StartSSL UI. If they forward the email the next day, then the token
        will already have expired.
    * If no, register it (at Namecheap or elsewhere).
  * Decide which image to run as the user's main website software (check out `../dockerfiles/sites/` to see which ones can be used for this)
  * Say you picked nginx, then create a text file containing just the word 'nginx' at
    `indiehosters/orchestration/per-server/k3/sites/example.com`
  * If you already have some content that should go on there, and which is compatible with the image you chose,
    put it in `indiehosters/user-data/example.com/nginx/` (replace 'nginx' with the actual image name you're using;
    note that for wordpress it's currently a bit more complicated, as this relies on more than one image, so you
    would then probably have to import both the user's wordpress folder and their mysql folder).
  * Unless there is already a TLS certificate at `indiehosters/user-data/example.com/tls.pem` get one
    (from StartSSL or elswhere) for example.com and concatenate the certificate
    and its unencrypted private key into `indiehosters/user-data/example.com/tls.pem`
  * Make sure the TLS certificate is valid (use `indiehosters/infrastructure/scripts/check-cert.sh` for this), and if it is,
    copy it from
    `indiehosters/user-data/example.com/tls.pem` 
    to `indiehosters/orchestration/TLS/approved-certs/example.com.pem`.
  * Now run `deploy/deploy.sh k3` again. It will make sure the server is in the correct state, and scp the user data and the
    approved cert into place, start a container running the image requested, update haproxy config, and restart the haproxy container.
  * Test the site using your /etc/hosts. If you did not import data, there should be some default message there. For wordpress, be aware
    that the site is installed in a state where any visitor can take control over it.
  * Switch DNS and note down the current DNS situation in `indiehosters/orchestration/DNS/example.com` (or if you're hosting
    a subdomain of another domain, update whichever is the zone file you edited).

## Deploying a mailserver

Right now, this is still a bit separate from the rest of the infrastructure - just get a server with Docker (doesn't have to be coreos), and run:

```bash
docker run -d -p 25:25 -p 443:443 indiehosters/yunohost /sbin/init
```

Then set up the mail domains and forwards through the web interface (with self-signed cert) on https://server.com/.
Use Chrome for this, because Firefox will refuse to let you view the admin interface because of the invalid TLS cert.
The initial admin password is 'changeme' - change it on https://server.com/yunohost/admin/#/tools/adminpw
