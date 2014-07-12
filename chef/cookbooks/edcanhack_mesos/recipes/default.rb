include_recipe "ubuntu"
include_recipe "python"

MESOS_DEB_URL="http://downloads.mesosphere.io/master/ubuntu/14.04/mesos_0.19.0~ubuntu14.04%2B1_amd64.deb"
MESOS_EGG_URL="http://downloads.mesosphere.io/master/ubuntu/14.04/mesos-0.19.0_rc2-py2.7-linux-x86_64.egg"
MARATHON_URL="http://downloads.mesosphere.io/marathon/marathon-0.4.0.tgz"

case node[:platform]
when "ubuntu"
  %w"zookeeperd default-jre python-setuptools python-protobuf curl htop zip unzip".each { |p| package p }
else
  raise "ubuntu only!"
end


remote_file "Mesos .deb" do
  source MESOS_DEB_URL
  path "/tmp/mesos.deb"
end
dpkg_package "Installing Mesos .deb" do
  source "/tmp/mesos.deb"
end


remote_file "Mesos .egg" do
  source MESOS_EGG_URL
  path "/tmp/mesos.egg"
end
bash "Installing Mesos .egg" do
  code "easy_install /tmp/mesos.egg"
end

user "marathon"
remote_file "Marathon .tar.gz" do
  source MARATHON_URL
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