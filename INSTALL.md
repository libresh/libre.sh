# Instructions to install LibrePaaS

## Recommendation
- API key on Namecheap (if you want to automatically buy domain name)

## Installation

First, you need a server.
You can take it from a cloud provider, like DigitalOcean or Scaleway and choose to spin up a VM with CoreOS already installed on it.

You can also buy a baremetal at [Hetzner](https://serverboerse.de/index.php?country=EN) as they are the cheapest options around. Follow these [instructions](INSTALL_HETZNER.md) in this case.

Copy this as your `user_data` and don't forget to change the hostname and your ssh key!

```
#cloud-config

hostname: $hostname
ssh_authorized_keys:
  - #your ssh public key here
write_files:
  - path: /etc/sysctl.d/aio-max.conf
    permissions: 0644
    owner: root
    content: "fs.aio-max-nr = 1048576"
  - path: /etc/hosts
    permissions: 0644
    owner: root
    content: |
      127.0.0.1 localhost
      255.255.255.255 broadcasthost
      ::1 localhost
  - path: /etc/environment
    permission: 0644
    owner: root
    content: |
      NAMECHEAP_URL="namecheap.com"
      NAMECHEAP_API_USER="pierreo"
      NAMECHEAP_API_KEY=
      IP=`curl -s http://icanhazip.com/`
      FirstName="Pierre"
      LastName="Ozoux"
      Address="23CalcadaSaoVicente"
      PostalCode="1100-567"
      Country="Portugal"
      Phone="+351.967184553"
      EmailAddress="pierre@ozoux.net"
      City="Lisbon"
      CountryCode="PT"
      BACKUP_DESTINATION=root@xxxxx:port
      MAIL_USER=contact%40indie.host
      MAIL_PASS=
      MAIL_HOST=mail.indie.host
      MAIL_PORT=587
coreos:
  update:
    reboot-strategy: off
  units:
    - name: systemd-sysctl.service
      command: restart
    - name: swap.service
      command: start
      content: |
        [Unit]
        Description=Turn on swap
        [Service]
        Type=oneshot
        RemainAfterExit=true
        ExecStartPre=-/bin/bash -euxc ' \
          fallocate -l 8192m /swap &&\
          chmod 600 /swap &&\
          mkswap /swap'
        ExecStart=/sbin/swapon /swap
        ExecStop=/sbin/swapoff /swap
        [Install]
        WantedBy=local.target
    - name: install-compose.service
      command: start
      content: |
        [Unit]
        Description=Install Docker Compose
        [Service]
        Type=oneshot
        RemainAfterExit=true
        ExecStart=-/bin/bash -euxc ' \
          mkdir -p /opt/bin &&\
          url=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r \'.assets[].browser_download_url | select(contains("Linux") and contains("x86_64"))\') &&\
          curl -L $url > /opt/bin/docker-compose &&\
          chmod +x /opt/bin/docker-compose'
    - name: install-indiehosters.service
      command: start
      content: |
        [Unit]
        Description=Install IndieHosters
        [Service]
        Type=oneshot
        RemainAfterExit=true
        ExecStart=-/bin/bash -euxc ' \
          git clone https://github.com/indiehosters/LibrePaaS.git /indiehosters &&\
          mkdir /{data,system} &&\
          mkdir /data/trash &&\
          cp /indiehosters/unit-files/* /etc/systemd/system && systemctl daemon-reload &&\
          cp /indiehosters/utils/* /opt/bin/'
```

And voila, your firet LibrePaaS node is ready!
