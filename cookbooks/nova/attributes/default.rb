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
default[:nova][:user] = "nova"
default[:nova][:user_group] = "nogroup"
default[:nova][:user_dir] = "/var/lib/nova"
default[:nova][:my_ip] = ipaddress
default[:nova][:api] = ""
default[:nova][:project] = "admin"
default[:nova][:images] = []
set_unless[:nova][:access_key] = secure_password
set_unless[:nova][:secret_key] = secure_password

default[:nova][:network_type] = "flat" # support "flatdhcp "flat" "dhcpvlan"
# Networking set for Flat DHCP
default[:nova][:flat_network_bridge] = "br100"
default[:nova][:public_interface] = "eth0"
default[:nova][:flat_netmask] = "255.255.255.0"
default[:nova][:flat_broadcast] = "192.168.11.255"
default[:nova][:flat_gateway] = "192.168.11.1"
default[:nova][:flat_nameserver] = "192.168.11.1"

# Networking set for Flat DHCP
default[:nova][:flat_dhcp_start] = "10.0.76.2"
default[:nova][:vlan_interface] = "eth0"
default[:nova][:floating_range] = "192.168.76.128/28"

default[:nova][:fixed_range] = "192.168.11.0/24"
default[:nova][:num_networks] = 2
default[:nova][:network_size] = 128
default[:nova][:flat_interface] = "eth1"

