include_recipe "edcanhack_mesos::mesos_base"

package "zookeeperd"

bash "disabling mesos-slave job" do
  code "echo 'manual' > /etc/init/mesos-slave.override"
end
