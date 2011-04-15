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

%w{swift-account swift-container swift-object xfsprogs}.each do |pkg|
  package pkg
end

template "/etc/rsyncd.conf" do
  source "rsyncd.conf.erb"
end

cookbook_file "/etc/default/rsync" do
  source "default-rsync"
end

service "rsync" do
  action :start
end

%w{account-server object-server container-server}.each do |service|
  template "/etc/swift/#{service}.conf" do
    source "#{service}-conf.erb"
    owner "swift"
    group "swift"
  end
end

cookbook_file "/usr/bin/start_swift_storage" do
  source "start_swift_storage"
  owner "swift"
  group "swift"
  mode "0755"
end

