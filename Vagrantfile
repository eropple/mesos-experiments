# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
IP_PREFIX = ENV['MESOS_EXPERIMENTS_IP_PREFIX'] || "10.218.147"
NUM_WORKERS = (ENV['MESOS_EXPERIMENTS_NUM_WORKERS'] || "1").to_i
NUM_MASTERS = (ENV['MESOS_EXPERIMENTS_NUM_MASTERS'] || "1").to_i
if NUM_MASTERS % 2 == 0
  raise "MESOS_EXPERIMENTS_NUM_MASTERS must be an odd number."
end

network_mapping = { }
(0...NUM_WORKERS).each do |i|
  network_mapping["worker-" + i.to_s.rjust(2, "0")] = "#{IP_PREFIX}.#{(100 + i).to_s}"
end
(0...NUM_MASTERS).each do |i|
  network_mapping["master-" + i.to_s.rjust(2, "0")] = "#{IP_PREFIX}.#{(10 + i).to_s}"
end
SHARED_JSON = {
  "hosts" => network_mapping,
  "masters" => network_mapping.select { |k, v| k.start_with?("master") },
  "zookeepers" => network_mapping.select { |k, v| k.start_with?("master") }
}

  
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu-14.04-chef"
  
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder './scripts', '/opt/scripts'
  
  (0...NUM_MASTERS).each do |i|
    master_name = "master-" + i.to_s.rjust(2, "0")
    
    config.vm.define master_name do |master|
      master.vm.hostname = master_name
      master.vm.network "private_network", ip: network_mapping[master_name]
    
      master.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", 1024]
      end
    
      master.vm.provision "chef_solo" do |chef|
        chef.cookbooks_path = [ "./chef/cookbooks", "./chef/librarian-cookbooks" ]
        chef.add_recipe "edcanhack_mesos::mesos_master"
        chef.add_recipe "edcanhack_mesos::marathon"
      
        chef.json = SHARED_JSON.merge({
          "set_fqdn" => master_name
        })
      end
    end
  end
  
  (0...NUM_WORKERS).each do |i|
    worker_name = "worker-" + i.to_s.rjust(2, "0")
    
    config.vm.define worker_name do |worker|
      worker.vm.hostname = worker_name
      worker.vm.network "private_network", ip: network_mapping[worker_name]
      
      worker.vm.provider "virtualbox" do |vbox|
        vbox.customize ["modifyvm", :id, "--memory", 2048]
      end
      
      worker.vm.provision "chef_solo" do |chef|
        chef.cookbooks_path = [ "./chef/cookbooks", "./chef/librarian-cookbooks" ]
        chef.add_recipe "edcanhack_mesos::mesos_slave"
      
        chef.json = SHARED_JSON.merge({
          "set_fqdn" => worker_name
        })
      end
    end
    
  end
end