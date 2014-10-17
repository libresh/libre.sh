# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

# Size of the CoreOS cluster created by Vagrant
$num_instances=1

# Official CoreOS channel from which updates should be downloaded
$update_channel='stable'

# Setting for VirtualBox VMs
$vb_memory = 1024
$vb_cpus = 1

BASE_IP_ADDR  = ENV['BASE_IP_ADDR'] || "192.168.65"
HOSTNAME = ENV['HOSTNAME'] || "indiehosters.dev"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  (1..$num_instances).each do |i|
    config.vm.define "core-#{i}" do |core|
      core.vm.provider :virtualbox do |vb|
        vb.memory = $vb_memory
        vb.cpus = $vb_cpus
        # On VirtualBox, we don't have guest additions or a functional vboxsf
        # in CoreOS, so tell Vagrant that so it can be smarter.
        vb.check_guest_additions = false
        vb.functional_vboxsf = false
      end
       # plugin conflict
      if Vagrant.has_plugin?("vagrant-vbguest") then
        core.vbguest.auto_update = false
      end

      core.vm.hostname = HOSTNAME
      core.hostsupdater.aliases = ["example.dev"]
      core.vm.network :private_network, ip: "#{BASE_IP_ADDR}.#{i+1}"
      core.vm.synced_folder ".", "/data/indiehosters", id: "coreos-indiehosters", :nfs => true, :mount_options => ['nolock,vers=3,udp']
      core.vm.provision :file, source: "./cloud-config", destination: "/tmp/vagrantfile-user-data"
      core.vm.provision :shell, inline: "cp /data/indiehosters/scripts/unsecure-certs/*.pem /data/server-wide/haproxy/approved-certs"
      core.vm.provision :shell, path: "./scripts/setup.sh", args: [HOSTNAME]
      core.vm.provision :shell, inline: "etcdctl set /services/default '{\"app\":\"nginx\", \"hostname\":\"#{HOSTNAME}\"}'"
      core.vm.provision :shell, path: "./scripts/approve-user.sh", args: [HOSTNAME, "nginx"]
    end
  end
end
