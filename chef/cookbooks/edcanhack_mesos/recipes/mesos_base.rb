include_recipe "edcanhack_mesos"

remote_file "Mesos .deb" do
  source node['mesos']['debpkg_url']
  path "/tmp/mesos.deb"
end
dpkg_package "Installing Mesos .deb" do
  source "/tmp/mesos.deb"
end


remote_file "Mesos .egg" do
  source node['mesos']['eggpkg_url']
  path "/tmp/mesos.egg"
end
bash "Installing Mesos .egg" do
  code "easy_install /tmp/mesos.egg"
end

MASTERS = node["hosts"].select { |k, v| node["masters"].include?(k) }
WORKERS = node["hosts"].select { |k, v| !node["masters"].include?(k) }
ZK_HOSTS = "zk://#{MASTERS.map { |k, v| v + ":2181"}.join(",")}"

bash "seeding /etc/mesos/zk" do
  code "echo '#{ZK_HOSTS}/mesos' > /etc/mesos/zk"
end