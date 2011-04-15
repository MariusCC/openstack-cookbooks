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

%w{curl swift-auth}.each do |pkg|
  package pkg
end

bash "create auth cert" do
  cwd "/etc/swift"
  command "/usr/bin/openssl req -new -x509 -nodes -out cert.crt -keyout cert.key -batch"
  not_if "test -e /etc/swift/cert.crt"
end

template "/etc/swift/auth-server.conf" do
  source "auth-server.conf.erb"
  mode "0644"
  owner "swift"
  group "swift"
end

cookbook_file "/usr/bin/start_swift_auth" do
  source "start_swith_auth"
  mode "0755"
  owner "swift"
  group "swift"
end


