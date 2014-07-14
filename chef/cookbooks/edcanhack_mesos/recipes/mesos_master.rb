include_recipe "edcanhack_mesos::mesos_base"

package "zookeeperd"

bash "disabling mesos-slave job" do
  code "echo 'manual' > /etc/init/mesos-slave.override"
end

template "Zookeeper configs for HA" do
  source "zoo.cfg.erb"
  path "/etc/zookeeper/conf/zoo.cfg"
end