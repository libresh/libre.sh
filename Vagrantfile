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
HOSTNAME = ENV['HOSTNAME'] || "coreos.dev"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  (1..$num_instances).each do |i|
    config.vm.define "core-#{i}" do |core|
      config.vm.provider :virtualbox do |vb|
        vb.memory = $vb_memory
        vb.cpus = $vb_cpus
      end

      core.vm.hostname = HOSTNAME
      core.vm.network :private_network, ip: "#{BASE_IP_ADDR}.#{i+1}"
      config.vm.synced_folder ".", "/data/infrastructure"
      core.vm.provision :file, source: "./config/user-data", destination: "/var/lib/coreos-vagrant/vagrantfile-user-data"
      core.vm.provision :shell, path: "./scripts/setup.sh"
      core.vm.provision :shell, path: "./scripts/adduser.sh", args: [HOSTNAME, "wordpress"]
    end
  end
end
