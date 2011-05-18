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

package "euca2ools"
package "unzip"

#user
execute "nova-manage project zipfile #{node[:nova][:project]} #{node[:nova][:user]} #{node[:nova][:user][:dir]}/nova.zip" do
  user 'nova'
  not_if {File.exists?("#{node[:nova][:user][:dir]}/nova.zip")}
end

execute "unzip -o /var/lib/nova/nova.zip -d #{node[:nova][:user][:dir]}/" do
  user node[:nova][:user]
  group node[:nova][:user][:group]
  not_if {File.exists?("#{node[:nova][:user][:dir]}/novarc")}
end

execute "cat #{node[:nova][:user][:dir]}/novarc >> #{node[:nova][:user][:dir]}/.bashrc" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user][:dir]}/.bashrc")}
end

#needed for sudo'ing commands as nova
execute "ln -s #{node[:nova][:user][:dir]}/.bashrc #{node[:nova][:user][:dir]}/.profile" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user][:dir]}/.profile")}
end

#project
execute "nova-manage user admin #{node[:nova][:user]} #{node[:nova][:access_key]} #{node[:nova][:secret_key]}" do
  user 'nova'
  not_if "nova-manage user list | grep #{node[:nova][:user]}"
end

execute "nova-manage project create #{node[:nova][:project]} #{node[:nova][:user]}" do
  user 'nova'
  not_if "nova-manage project list | grep #{node[:nova][:project]}"
end

execute "nova-manage network create #{node[:nova][:proj_network]} #{node[:nova][:proj_network_count]} #{node[:nova][:proj_network_per_count_size]}" do
  user 'nova'
  not_if { File.exists?("/var/lib/nova/setup") }
end

execute "nova-manage floating create #{node[:nova][:hostname]} #{node[:nova][:floating_range]}" do
  user 'nova'
  not_if { File.exists?("/var/lib/nova/setup") }
end

file "/var/lib/nova/setup" do
  action :touch
  not_if { File.exists?("/var/lib/nova/setup") }
end

