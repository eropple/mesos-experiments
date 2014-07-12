# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
IP_PREFIX = ENV['MESOS_EXPERIMENTS_IP_PREFIX'] || "10.218.147"
NUM_WORKERS = ENV['MESOS_EXPERIMENTS_NUM_WORKERS'] || 2

network_mapping = { "master" => "#{IP_PREFIX}.10" }
(0...NUM_WORKERS).each do |i|
  network_mapping["worker_" + i.to_s.rjust(2, "0")] = "#{IP_PREFIX}.#{(100 + i).to_s}"
end
SHARED_JSON = {
  "hosts" => network_mapping,
  "masters" => [ "master" ]
}

  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-14.04-chef"
  
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder './scripts', '/opt/scripts'
  
  config.vm.define "master" do |master|
    master.vm.network "private_network", ip: network_mapping["master"]
    
    master.vm.network "forwarded_port", guest: 8080, host: 8080
    master.vm.network "forwarded_port", guest: 5050, host: 5050
    
    master.vm.provider "virtualbox" do |vbox|
      vbox.customize ["modifyvm", :id, "--memory", 1024]
    end
    
    master.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = [ "./chef/cookbooks", "./chef/librarian-cookbooks" ]
      chef.add_recipe "edcanhack_mesos::mesos_master"
      chef.add_recipe "edcanhack_mesos::marathon"
      
      chef.json = SHARED_JSON
    end
  end
  
  (0...NUM_WORKERS).each do |i|
    worker_name = "worker_" + i.to_s.rjust(2, "0")
    
    config.vm.define worker_name do |worker|
      worker.vm.network "private_network", ip: network_mapping[worker_name]
      
      worker.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", 2048]
      end
      
      worker.vm.provision "chef_solo" do |chef|
        chef.cookbooks_path = [ "./chef/cookbooks", "./chef/librarian-cookbooks" ]
        chef.add_recipe "edcanhack_mesos::mesos_slave"
      
        chef.json = SHARED_JSON
      end
    end
    
  end
end