include_recipe "edcanhack_mesos::mesos_base"

bash "disabling mesos-master job" do
  code "echo 'manual' > /etc/init/mesos-master.override"
end