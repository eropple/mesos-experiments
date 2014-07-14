include_recipe "ubuntu"
include_recipe "python"
include_recipe "hostname"

case node[:platform]
when "ubuntu"
  %w"default-jre python-setuptools python-protobuf curl htop zip unzip".each { |p| package p }
else
  raise "ubuntu only!"
end

remote_file "archive hosts file" do 
  path "/etc/hosts.old" 
  source "file:///etc/hosts"
  owner 'root'
  group 'root'
  mode 0755
end

template "new hosts file" do
  source "hosts.erb"
  path "/etc/hosts"
end


remote_file "zookeeper-cli" do
  path "/tmp/zookeeper-cli.tar.gz"
  source node['zookeeper-cli_url']
end
bash "installing zookeeper-cli" do
  code <<-ENDCODE
  if [[ ! -d /opt/zookeeper-cli ]]
    then
    
    mkdir -p /opt/zookeeper-cli
    cd /opt/zookeeper-cli
    tar --strip-components=1 -xzvf /tmp/zookeeper-cli.tar.gz
    rm /tmp/zookeeper-cli.tar.gz
    chmod +x /opt/zookeeper-cli/bin/zk
    ln -s /opt/zookeeper-cli/bin/zk /usr/local/bin/zk
  fi
  ENDCODE
end

template "adding masters list to /usr/local/share/masters.list" do
  source "host_list.erb"
  path "/usr/local/share/masters.list"
  variables({
    :hosts => node["masters"]
  })
end

template "adding zookeepers list to /usr/local/share/zookeepers.list" do
  source "host_list.erb"
  path "/usr/local/share/zookeepers.list"
  variables({
    :hosts => node["zookeepers"]
  })
end

%w"mesos-leading-master.rb".each do |file|
  cookbook_file file do
    path "/usr/local/bin/#{file}"
    mode 0755
  end
end