include_recipe "edcanhack_mesos::mesos_base"

package "zookeeperd"

bash "setting mesos quorum" do
  code "echo '#{(node['masters'].length / 2.0).ceil}' > /etc/mesos-master/quorum"
end

bash "disabling mesos-slave job" do
  code "echo 'manual' > /etc/init/mesos-slave.override"
end

template "Zookeeper configs for HA" do
  source "zoo.cfg.erb"
  path "/etc/zookeeper/conf/zoo.cfg"
end
bash "seeding Zookeeper myid file" do
  code "ruby -e 'puts `hostname`.split(\"-\")[1].to_i + 1' > /var/lib/zookeeper/myid"
end
