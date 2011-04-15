#
# Cookbook Name:: nova
# Recipe:: common
#
# Copyright 2010, 2011 Opscode, Inc.
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

include_recipe "apt"

#deb http://ppa.launchpad.net/nova-core/release/ubuntu maverick main 
if node[:cc_config].nil?
  apt_repository "NovaCoreReleasePPA" do
    uri "http://ppa.launchpad.net/nova-core/release/ubuntu"
    distribution node["lsb"]["codename"]
    components ["main"]
    action :add
  end
end

package "nova-common" do
  options "--force-yes -o Dpkg::Options::=\"--force-confdef\""
  action :install
end

if node[:nova_environment].nil?
  if node.run_list.roles.include?('nova-single-machine')
    node[:nova_environment] = node[:fqdn]
  else
    node[:nova_environment] = "default"
  end
  node.save
end

env_filter = " AND nova_environment:#{node[:nova_environment]}"

sql_connection = nil
if node[:nova][:mysql]
  Chef::Log.info("Using mysql")
  package "python-mysqldb"
  mysqls = nil

  mysqls = search(:node, "recipes:nova\\:\\:mysql#{env_filter}")
  if mysqls and mysqls[0]
    mysql = mysqls[0]
    Chef::Log.info("Mysql server found at #{mysql[:mysql][:bind_address]}")
  else
    mysql = node
    Chef::Log.info("Using local mysql at #{mysql[:mysql][:bind_address]}")
  end
  sql_connection = "mysql://#{mysql[:nova][:db][:user]}:#{mysql[:nova][:db][:password]}@#{mysql[:mysql][:bind_address]}/#{mysql[:nova][:db][:database]}"
end

rabbits = search(:node, "recipes:nova\\:\\:rabbit#{env_filter}")
if rabbits and rabbits[0]
  rabbit = rabbits[0]
  Chef::Log.info("Rabbit server found at #{rabbit[:rabbitmq][:address]}")
else
  rabbit = node
  Chef::Log.info("Using local rabbit at #{rabbit[:rabbitmq][:address]}")
end

apis = search(:node, "recipes:nova\\:\\:api#{env_filter}")
if apis and (apis.length > 0)
  api = apis[0]
  Chef::Log.info("Api server found at #{api[:nova][:my_ip]}")
else
  api = node
  Chef::Log.info("Api server found at #{api[:nova][:my_ip]}")
end

objectstores = search(:node, "recipes:nova\\:\\:objectstore#{env_filter}")
if objectstores and (objectstores.length > 0)
  objectstore = objectstores[0]
  Chef::Log.info("Objectstore server found at #{objectstore[:nova][:my_ip]}")
else
  objectstore = node
  Chef::Log.info("Objectstore server found at #{objectstore[:nova][:my_ip]}")
end

networks = search(:node, "recipes:nova\\:\\:network#{env_filter}")
if networks and (networks.length > 0)
  network = networks[0]
  Chef::Log.info("Network server found at #{network[:nova][:my_ip]}")
else
  network = node
  Chef::Log.info("Network server found at #{network[:nova][:my_ip]}")
end

# if node[:nova][:network_ip].nil?
#   node[:nova][:network_ip] = network
# end

rabbit_settings = {
  :address => rabbit[:rabbitmq][:address],
  :port => rabbit[:rabbitmq][:port],
  :user => rabbit[:nova][:rabbit][:user],
  :password => rabbit[:nova][:rabbit][:password],
  :vhost => rabbit[:nova][:rabbit][:vhost]
}

execute "nova-manage db sync" do
  user "nova"
  action :nothing
end

cookbook_file "/etc/default/nova-common" do
  source "nova-common"
  owner "root"
  group "root"
  mode 0644
  action :nothing
end

template "/etc/nova/nova.conf" do
  source "nova.conf.erb"
  owner "root"
  group "root"
  mode 0644
  variables(
            :sql_connection => sql_connection,
            :rabbit_settings => rabbit_settings,
            :s3_host => objectstore[:nova][:my_ip],
            :cc_host => api[:nova][:my_ip]
            )
  notifies :run, resources(:execute => "nova-manage db sync"), :immediately
  notifies :create_if_missing, resources(:cookbook_file => "/etc/default/nova-common"), :immediately
end
