include_recipe "edcanhack_mesos::mesos_base"

package "zookeeperd"

bash "disabling mesos-slave job" do
  code "echo 'manual' > /etc/init/mesos-slave.override"
end

MASTERS = node["hosts"].select { |k, v| node["masters"].include?(k) }
WORKERS = node["hosts"].select { |k, v| !node["masters"].include?(k) }
ZK_HOSTS = "zk://#{MASTERS.map { |k, v| v + ":2181"}.join(",")}"
template "Mesos master defaults" do
  source "defaults_mesos-master.erb"
  path "/etc/default/mesos-master"
  variables ({
    :zk_hosts => ZK_HOSTS
  })
end