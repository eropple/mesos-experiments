include_recipe "edcanhack_mesos::mesos_base"

user "marathon"
remote_file "Marathon .tar.gz" do
  source node['mesos']['marathon_url']
  path "/tmp/marathon.tar.gz"
end
bash "Installing Marathon" do
  code <<-ENDCODE
  cd /opt
  tar xzvf /tmp/marathon.tar.gz
  ENDCODE
end
cookbook_file "Adding Marathon upstart script" do
  source "marathon_upstart.conf"
  path "/etc/init/marathon.conf"
end

MASTERS = node["hosts"].select { |k, v| node["masters"].include?(k) }
WORKERS = node["hosts"].select { |k, v| !node["masters"].include?(k) }
ZK_HOSTS = "zk://#{MASTERS.map { |k, v| v + ":2181"}.join(",")}"

template "Marathon defaults" do
  source "defaults_marathon.erb"
  path "/etc/default/marathon"
  variables ({
    :zk_hosts => ZK_HOSTS
  })
end