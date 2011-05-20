#
# Cookbook Name:: nova
# Attributes:: default
#
# Copyright 2010-2011, Opscode, Inc.
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

::Chef::Node.send(:include, Opscode::OpenSSL::Password)

#database settings
default[:nova][:db][:password] = "" #set by recipe
default[:nova][:db][:user] = "nova"
default[:nova][:db][:database] = "nova"
default[:nova][:mysql] = false

#rabbitmq settings
set_unless[:nova][:rabbit][:password] = secure_password
default[:nova][:rabbit][:user] = "nova"
default[:nova][:rabbit][:vhost] = "/nova"

#hypervisor settings
default[:nova][:libvirt_type] = "kvm"

#shared settings
default[:nova][:hostname] = "nova"
default[:nova][:install_type] = "binary"
default[:nova][:user] = "nova"
default[:nova][:user_group] = "nogroup"
default[:nova][:user_dir] = "/var/lib/nova"
default[:nova][:my_ip] = ipaddress
default[:nova][:api] = ""
default[:nova][:images] = []
default[:nova][:network_type] = "flat" # support "flatdhcp "flat" "dhcpvlan"

#
# Flat parameters
#
default[:nova][:fixed_range] = "192.168.124.0/24"
default[:nova][:network_size] = "128"
default[:nova][:flat_network_bridge] = "br100"
#default[:nova][:netmask] = "#{node[:network][:interfaces][node[:nova][:public_interface]][:addresses][node[:nova][:my_ip]][:netmask]
#default[:nova][:broadcast] = "#{node[:network][:interfaces][node[:nova][:public_interface]][:addresses][node[:nova][:my_ip]][:broadcast]
#default[:nova][:dns_nameserver] = "#{node[:network][:interfaces][node[:nova][:public_interface]][:addresses][node[:nova][:my_ip]][:broadcast]
default[:nova][:flat_injected] = "True"
#
# Flat DHCP Parameters
#
default[:nova][:public_interface] = "eth0"
default[:nova][:vlan_interface] = "eth1"
default[:nova][:network_dhcp_start] = "192.168.124.128"
#
# DHCP Vlan Parameters
# ???
#
default[:nova][:floating_range] = "10.128.0.0/24"
default[:nova][:project] = "admin"
set_unless[:nova][:access_key] = secure_password
set_unless[:nova][:secret_key] = secure_password
#
# Default project networking
#
default[:nova][:proj_network] = "192.168.124.0/24"
default[:nova][:proj_network_count] = "1"
default[:nova][:proj_network_per_count_size] = "128"

