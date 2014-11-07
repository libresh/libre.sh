# Deploying a server

## Before you start
Make sure you read [getting started](getting-started-as-a-hoster.md) first.

### Prepare your orchestration data
* Get a CoreOS server, for instance from [RackSpace](rackspace.com) or [Vultr](vultr.com).
* If you didn't add your public ssh key during the order process (e.g. through your IaaS control panel or a cloud-config file),
  scp your laptop's public ssh key (probably in `~/.ssh/id_rsa.pub`) to `.ssh/authorized_keys` for the remote user
  you will be ssh-ing and scp-ing as (the default remote user of our deploy scripts is 'core').
* Give the new server a name (in this example, we call the server 'k3')
* Add k3 to your /etc/hosts with the right IP address
* If you have used this name before, run `./deploy/forget-server-fingerprint.sh k3`
* ssh into your server, and run `ssh-keygen -t rsa`  (use all the default settings, empty passphrase)
* set up a backups server at an independent location (at least a different data center, but preferably also a different IaaS provider, the bu25 plan of https://securedragon.net/ is a good option at 3 dollars per month).
* set up a git server by following http://www.git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server (no need to set up any repos like 'project.git' yet).  Let's call the backup server 'bu25' (add this to /etc/hosts on k3).
* add the ssh key from k3 to the authorized_keys for the git user (not the root user) on bu25.
* Exit from the double ssh back to your laptop, and from the root folder of this repository, run `sh ./deploy/deploy.sh k3 git@bu25 master root`
* The rest should be automatic!

### Adding a website to your server
* For each site you want to deploy on the server, e.g. example.com, do the following:
  * Does example.com already exist as a domain name?
    * If yes, then find out to what extent it's currently in use (and needs to be migrated with care). There are a few options:
      * Transfer the domain into your DNR account
      * Set up DNS hosting for it and ask the owner to set authoritative DNS to the DNS servers you control
      * Ask the user to keep DNR and DNS control where it is currently, but to switch DNS when it's ready at the new server, and every time
        you add or remove an IP address (not a good idea, unless the user insists that they prefer this option)
      * In any case, you will probably need access to the hostmaster@example.com email address, for the StartSSL process *before*
        the final DNS switch. You could also ask them to tell you the verification code that arrives there, but that has to be done
        in real time, immediately when you click 'verify' in the StartSSL UI. If they forward the email the next day, then the token
        will already have expired.
    * If no, register it (at Namecheap or elsewhere).
  * Decide which image to run as the user's main website software (in version 0.2, 'static', 'static-git', and 'wordpress' are supported)
  * For the 'wordpress' image, all you need is the TLS certificate. Use the 'static-git' image if you already have some static
    content that should go on there, and which you can put in a public git repository somewhere.
  * Unless you already have a TLS certificate for example.com, get one
    (from StartSSL or elsewhere), and concatenate the certificate
    and its unencrypted private key into one file.
  * Make sure the TLS certificate is valid (use `scripts/check-cert.sh` for this), and scp it to `/data/import/example.com/TLS/example.com.pem` on k3.
  * Now ssh into k3, and if for instance 'wordpress' is the image you chose, run:

    systemctl enable wordpress@example.com
    systemctl start wordpress@example.com

  * In case you're going for the 'static-git' repo, store the git url with the content in `/data/domains/example.com/static-git/GITURL`.
  * In case you're going for the 'static' repo, store the html content under `/data/domains/example.com/static/www-content`.
  * Test the site using your /etc/hosts. You should see the data from the git repo, or the static content, or a wordpress start page
    on both http and https.
  * Switch DNS and monitoring.
