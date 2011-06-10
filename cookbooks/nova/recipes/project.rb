#
# Cookbook Name:: nova
# Recipe:: project
#
# Copyright 2010-2011, Opscode, Inc.
# Copyright 2011, Anso Labs
# Copyright 2011, Dell, Inc.
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

package "euca2ools"
package "unzip"

#project
execute "nova-manage user admin #{node[:nova][:user]} #{node[:nova][:access_key]} #{node[:nova][:secret_key]}" do
  user node[:nova][:user]
  not_if "nova-manage user list | grep #{node[:nova][:user]}"
end

execute "nova-manage project create #{node[:nova][:project]} #{node[:nova][:user]}" do
  user node[:nova][:user]
  not_if "nova-manage project list | grep #{node[:nova][:project]}"
end

execute "nova-manage network create #{node[:nova][:fixed_range]} #{node[:nova][:num_networks]} #{node[:nova][:network_size]}" do
  user node[:nova][:user]
  not_if { File.exists?("/var/lib/nova/setup") }
end

if node[:nova][:network_type] != "flat"
  execute "nova-manage floating create #{node[:nova][:hostname]} #{node[:nova][:floating_range]}" do
    user node[:nova][:user]
    not_if { File.exists?("/var/lib/nova/setup") }
  end
end

#user credentials and environment settings
execute "nova-manage project zipfile #{node[:nova][:project]} #{node[:nova][:user]} #{node[:nova][:user_dir]}/nova.zip" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/nova.zip")}
end

execute "unzip -o /var/lib/nova/nova.zip -d #{node[:nova][:user_dir]}/" do
  user node[:nova][:user]
  group node[:nova][:user_group]
  not_if {File.exists?("#{node[:nova][:user_dir]}/novarc")}
end

link "#{node[:nova][:user_dir]}/.bashrc" do
  to "#{node[:nova][:user_dir]}/novarc"
  owner node[:nova][:user]
  group node[:nova][:user_group]
end

link "#{node[:nova][:user_dir]}/.profile" do
  to "#{node[:nova][:user_dir]}/novarc"
  owner node[:nova][:user]
  group node[:nova][:user_group]
end

#generate a private key
execute "euca-add-keypair --config #{node[:nova][:user_dir]}/novarc mykey > #{node[:nova][:user_dir]}/mykey.priv" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/mykey.priv")}
end

execute "chmod 0600 #{node[:nova][:user_dir]}/mykey.priv" do
  user node[:nova][:user]
end

file "/var/lib/nova/setup" do
  action :touch
  not_if { File.exists?("/var/lib/nova/setup") }
end

cmd = Chef::ShellOut.new("sudo -i -u #{node[:nova][:user]} euca-describe-groups")
groups = cmd.run_command
Chef::Log.debug groups

execute "euca-authorize --config #{node[:nova][:user_dir]}/novarc -P icmp -t -1:-1 default" do
  user node[:nova][:user]
  not_if {groups.stdout.include?("icmp")}
end

execute "euca-authorize --config #{node[:nova][:user_dir]}/novarc -P tcp -p 22 default" do
  user node[:nova][:user]
  not_if {groups.stdout.include?("tcp")}
end
