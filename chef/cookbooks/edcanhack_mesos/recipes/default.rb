include_recipe "ubuntu"
include_recipe "python"

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