#
# Cookbook Name:: nova
# Recipe:: finalize
#
# Copyright 2011, Opscode
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'chef/shell_out'

#from http://wiki.openstack.org/NovaInstall/MultipleServer
#Step 3 - Restart all relevant services
services = %w{nova-network nova-api nova-objectstore nova-scheduler}
services.each do |svc|
  service "#{svc}" do
    if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
      action :restart
    end
  end
end

#Step 4 - Closing steps, and cleaning up
cmd = Chef::ShellOut.new("sudo -i -u #{node[:nova][:user]} euca-describe-groups")
groups = cmd.run_command

execute "su - #{node[:nova][:user]} -c 'euca-authorize -P icmp -t -1:-1 default'" do
  user "root"
  not_if {groups.stdout.include?("icmp")}
end

execute "su - #{node[:nova][:user]} -c 'euca-authorize -P tcp -p 22 default'" do
  user "root"
  not_if {groups.stdout.include?("tcp")}
end

execute "killall dnsmasq" do
  user "root"
  returns [0,1]
end
  
service "nova-network" do
  action :restart
end

#If you want to use the 10.04 Ubuntu Enterprise Cloud images that are readily available at http://uec-images.ubuntu.com/releases/10.04/release/, you may run into delays with booting. Any server that does not have nova-api running on it needs this iptables entry so that UEC images can get metadata info. On compute nodes, configure the iptables with this next step:
execute "iptables -t nat -A PREROUTING -d 169.254.169.254/32 -p tcp -m tcp --dport 80 -j DNAT --to-destination $NOVA_API_IP:8773"

execute "su - #{node[:nova][:user]} -c 'euca-add-keypair mykey > #{node[:nova][:user][:dir]}/mykey.priv'" do
  user "root"
  not_if {File.exists?("#{node[:nova][:user][:dir]}/mykey.priv")}
end

#generate a private key
execute "chmod 0600 #{node[:nova][:user][:dir]}/mykey.priv" do
  user node[:nova][:user]
end

#download and install AMIs
(node[:nova][:images] or []).each do |image|
  #get the filename of the image
  filename = image.split('/').last  
  execute "su - #{node[:nova][:user]} -c 'uec-publish-tarball #{node[:nova][:user][:dir]}/images/#{filename} nova_amis x86_64'" do
    cwd "#{node[:nova][:user][:dir]}/images/"
    user "root"
    action :nothing
  end
  remote_file image do
    source image
    path "#{node[:nova][:user][:dir]}/images/#{filename}"
    owner node[:nova][:user]
    notifies :run, resources(:execute => "su - #{node[:nova][:user]} -c 'uec-publish-tarball #{node[:nova][:user][:dir]}/images/#{filename} nova_amis x86_64'"), :immediate
  end
end

#debug output
# execute "nova-manage service list" do
#   user node[:nova][:user]
# end

# #debug output
# execute "euca-describe-images" do
#   user node[:nova][:user]
# end

