#
# Cookbook Name:: nova
# Recipe:: config
#
# Copyright 2010, 2011 Opscode, Inc.
# Copyright 2011 Dell, Inc.
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

#deb http://ppa.launchpad.net/nova-core/release/ubuntu maverick main 
#if node[:crowbar].nil?
apt_repository "NovaCoreReleasePPA" do
  uri "http://ppa.launchpad.net/nova-core/release/ubuntu"
  distribution node["lsb"]["codename"]
  components ["main"]
  action :add
end
#end

package "nova-common" do
  options "--force-yes -o Dpkg::Options::=\"--force-confdef\""
  action :install
end

#OPEN A BUG!!!
execute "fix #{node[:nova][:userdir]} permissions" do
  command "chown #{node[:nova][:user]}:#{node[:nova][:user_group]} #{node[:nova][:user_dir]}"
end


# env_filter = " AND nova_config_environment:#{node[:nova][:config][:environment]}"

# sql_connection = nil
# if node[:nova][:mysql]
#   Chef::Log.info("Using mysql")
#   package "python-mysqldb"
#   mysqls = nil

#   mysqls = search(:node, "recipes:nova\\:\\:mysql#{env_filter}")
#   if mysqls and mysqls[0]
#     mysql = mysqls[0]
#     Chef::Log.info("Mysql server found at #{mysql[:mysql][:bind_address]}")
#   else
#     mysql = node
#     Chef::Log.info("Using local mysql at  #{mysql[:mysql][:bind_address]}")
#   end

#   mysql_address = mysql[:mysql][:bind_address]
# #  mysql_address = Barclamp::Inventory.get_network_by_type(mysql, "admin").address if mysql_address.nil?

#   sql_connection = "mysql://#{mysql[:nova][:db][:user]}:#{mysql[:nova][:db][:password]}@#{mysql_address}/#{mysql[:nova][:db][:database]}"
# end

# rabbits = nil
# rabbits = search(:node, "recipes:nova\\:\\:rabbit#{env_filter}")
# if rabbits and rabbits[0]
#   rabbit = rabbits[0]
#   Chef::Log.info("Rabbit server found at #{rabbit[:rabbitmq][:address]}")
# else
#   rabbit = node
#   Chef::Log.info("Using local rabbit at #{rabbit[:rabbitmq][:address]}")
# end

# rabbit_address = rabbit[:rabbitmq][:address]
# #rabbit_address = Barclamp::Inventory.get_network_by_type(rabbit, "admin").address if rabbit_address.nil? or rabbit_address == "0.0.0.0"
# rabbit_settings = {
#   :address => rabbit_address,
#   :port => rabbit[:rabbitmq][:port],
#   :user => rabbit[:nova][:rabbit][:user],
#   :password => rabbit[:nova][:rabbit][:password],
#   :vhost => rabbit[:nova][:rabbit][:vhost]
# }

# apis = nil
# apis = search(:node, "recipes:nova\\:\\:api#{env_filter}")
# if apis and (apis.length > 0)
#   api = apis[0]
#   Chef::Log.info("Api server found at #{api[:nova][:my_ip]}")
# else
#   api = node
#   Chef::Log.info("Api server found at #{api[:nova][:my_ip]}")
# end

# objectstores = nil
# objectstores = search(:node, "recipes:nova\\:\\:objectstore#{env_filter}")
# if objectstores and (objectstores.length > 0)
#   objectstore = objectstores[0]
#   Chef::Log.info("Objectstore server found at #{objectstore[:nova][:my_ip]}")
# else
#   objectstore = node
#   Chef::Log.info("Objectstore server found at #{objectstore[:nova][:my_ip]}")
# end

# networks = nil
# networks = search(:node, "recipes:nova\\:\\:network#{env_filter}")
# if networks and (networks.length > 0)
#   network = networks[0]
#   Chef::Log.info("Network server found at #{network[:nova][:my_ip]}")
# else
#   network = node
#   Chef::Log.info("Network server found at #{network[:nova][:my_ip]}")
# end

# execute "nova-manage db sync" do
#   user "nova"
#   action :nothing
# end

# cookbook_file "/etc/default/nova-common" do
#   source "nova-common"
#   owner "root"
#   group "root"
#   mode 0644
#   action :nothing
# end

# #objectstore_ip = Barclamp::Inventory.get_network_by_type(objectstore, "admin").address
# api_ip = Barclamp::Inventory.get_network_by_type(api, "admin").address

# template "/etc/nova/nova.conf" do
#   source "nova.conf.erb"
#   owner "root"
#   group "root"
#   mode 0644
#   variables(
#             :sql_connection => sql_connection,
#             :rabbit_settings => rabbit_settings,
#             :s3_host => objectstore_ip,
#             :cc_host => api_ip
#             )
#   notifies :run, resources(:execute => "nova-manage db sync"), :immediately
#   notifies :create_if_missing, resources(:cookbook_file => "/etc/default/nova-common"), :immediately
# end

