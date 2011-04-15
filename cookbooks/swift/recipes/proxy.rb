#
# Cookbook Name:: cloudfiles
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
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

include_recipe 'apt'
include_recipe 'utils'

%w{memcached swift-proxy}.each do |pkg|
  package pkg
end

bash "create proxy cert" do
  cwd "/etc/swift"
  command "/usr/bin/openssl req -new -x509 -nodes -out cert.crt -keyout cert.key -batch"
  not_if "test -e /etc/swift/cert.crt"
end

# GREG: FIX THIS!!!
utils_line "-l 192.168.124.10" do
  action :add
  file "/etc/memcached.conf"
  notifies :run, resources(:service => "memcached"), :delayed
end 

utils_line "-l 127.0.0.1" do
  action :remove
  file "/etc/memcached.conf"
  notifies :run, resources(:service => "memcached"), :delayed
end 

service memcached do
end

template "/etc/swift/proxy-server.conf" do
  source "proxy-server.conf.erb"
  mode "0644"
  owner "swift"
  group "swift"
end

cookbook_file "/usr/bin/start_swift_proxy" do
  source "start_swith_proxy"
  mode "0755"
  owner "swift"
  group "swift"
end



