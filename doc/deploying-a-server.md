# Deploying a server

## Before you start
Make sure you read [getting started](getting-started-as-a-hoster.md) first.

### Prepare your orchestration data
* Get a CoreOS or Ubuntu server, for instance from [RackSpace](rackspace.com) or [Vultr](vultr.com).
* If you chose Ubuntu, follow the [Ubuntu-specific](running-on-ubuntu.md) instructions, then continue here.
* If you didn't add your public ssh key during the order process (e.g. through your IaaS control panel or a cloud-config file),
  scp your laptop's public ssh key (probably in `~/.ssh/id_rsa.pub`) to `.ssh/authorized_keys` for the remote user
  you will be ssh-ing and scp-ing as (the default remote user of our deploy scripts is 'core').
* Give the new server a name (in this example, we call the server 'k3')
* Add k3 to your /etc/hosts with the right IP address
* If you have used this name before, run `ssh-keygen -R k3`
* Ssh into your server, and run `ssh-keygen -t rsa`  (use all the default settings, empty passphrase)
* Set up a backups server at an independent location (at least a different data center, but preferably also a different IaaS provider, the bu25 plan of https://securedragon.net/ is a good option at 3 dollars per month).
* Set up a git server by following http://www.git-scm.com/book/en/v2/Git-on-the-Server-Setting-Up-the-Server (no need to set up any repos like 'project.git' yet).  Let's call the backup server 'bu25' (add this to /etc/hosts on k3).
* Add the ssh key from k3:.ssh/id_rsa.pub to the authorized_keys for the git user (not the root user) on bu25.
* Check that you can `ssh git@bu25` from k3.
* Exit from the double ssh back to your laptop, and from the root folder of this repository, run `sh ./deploy/deploy.sh k3 git@bu25 master root`
* The rest should be automatic! (ignore the warning about backup.dev, and note that haproxy will not start as long as there are no website on your server).

### Adding an existing website
* The IndieHosters architecture is migration-oriented, so it aims to make moving a domain from one server to another very easy.
* If you already have a domain in backups, say example.com, then it's easy to add it to this new server.
* Say domain example.com runs the 'static' image. Then ssh into k3, and run:

````bash
    systemctl enable static@example.com
    systemctl start static@example.com
````

* This will automatically do the following things:
  * Clone the backup repo from bu25
  * Set up an hourly backup job for the user data (which will live in `/data/domains/example.com` on k3)
  * Start an nginx container
  * Note its IP address in etcd
  * Rewrite the haproxy configuration
  * (Re)start haproxy

### Adding a new website to your server
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
  * If all looks well, switch DNS and monitoring.
  * If not, check what happened by looking at what's in `/data/domains/example.com`, `data/runtime/domains/example.com`, and `/data/runtime/haproxy` on k3. Note that this part of our scripts is currently a bit complex, we will clean this up in a next version. There are six different scripts that try to initialize the contents of `/data/domains/example.com`:
    * The git clone from the back up service (will try to initialize an empty git repository)
    * The local data import process (will try to move the data from `/data/import/example.com` into place
    * The wordpress image (which we used from the wordpress-stackable Dockerfile published by Tutum)
    * The mysql image (which we used from the mysql Dockerfile published by Tutum)
    * The wordpress importer (a one-time systemd task)
    * The mysql importer (a one-time systemd task)
  * It might help to remove /data/domains/example.com, /data/runtime/domains/example.com, and /etc/systemd/system/*/*example.com*, and remove the git@bu25:example.com repo from the backup server, make sure /data/import/example.com/TLS/example.com.pem exists, make sure /data/BACKUP_DESTINATION contains git@bu25 (and not core@backup.dev), shutdown -r now, and retry.
  * If you're setting up a fresh wordpress site, you have to access the admin panel over http first (e.g. run it `-p 80:80`), and activate the [https plugin](https://wordpress.org/plugins/wordpress-https/) before it will work behind the haproxy SSL-offloader.
