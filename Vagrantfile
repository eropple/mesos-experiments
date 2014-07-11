# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-14.04-chef"
  config.vm.synced_folder '.', '/vagrant', disabled: true
  
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = [ "./chef/cookbooks", "./chef/librarian-cookbooks" ]
    chef.add_recipe "edcanhack_mesos"
    
    chef.json = {}
  end
end
