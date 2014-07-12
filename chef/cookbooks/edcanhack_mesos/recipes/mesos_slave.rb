include_recipe "edcanhack_mesos::mesos_base"

bash "disabling mesos-master job" do
  code "echo 'manual' > /etc/init/mesos-master.override"
end

MASTERS = node["hosts"].select { |k, v| node["masters"].include?(k) }
WORKERS = node["hosts"].select { |k, v| !node["masters"].include?(k) }
ZK_HOSTS = "zk://#{MASTERS.map { |k, v| v + ":2181"}.join(",")}"
template "Mesos slave defaults" do
  source "defaults_mesos-slave.erb"
  path "/etc/default/mesos-slave"
  variables ({
    :zk_hosts => ZK_HOSTS
  })
end