include_recipe "edcanhack_mesos::mesos_base"

package "haproxy"

bash "disabling mesos-master job" do
  code "echo 'manual' > /etc/init/mesos-master.override"
end

%w"marathon-haproxy-cfg.bash haproxy-update.bash".each do |file|
  cookbook_file file do
    path "/usr/local/bin/#{file}"
    mode 0755
  end
end

cron "haproxy update" do
  minute "*"
  hour "*"
  day "*"
  weekday "*"
  user "root"
  command "/usr/local/bin/haproxy-update.bash"
end