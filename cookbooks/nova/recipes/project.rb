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

execute "nova-manage network create #{node[:nova][:proj_network]} #{node[:nova][:proj_network_count]} #{node[:nova][:proj_network_per_count_size]}" do
  user node[:nova][:user]
  not_if { File.exists?("/var/lib/nova/setup") }
end

execute "nova-manage floating create #{node[:nova][:hostname]} #{node[:nova][:floating_range]}" do
  user node[:nova][:user]
  not_if { File.exists?("/var/lib/nova/setup") }
end

#user credentials and environment settings
execute "nova-manage project zipfile #{node[:nova][:project]} #{node[:nova][:user]} #{node[:nova][:user_dir]}/nova.zip" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/nova.zip")}
end

# [[ ! -f $novarc.bak ]] && cp $novarc{,.bak}
# sed -i "s/127.0.0.1/$cc_host_ip/g" $novarc
# echo 'done'

execute "unzip -o /var/lib/nova/nova.zip -d #{node[:nova][:user_dir]}/" do
  user node[:nova][:user]
  group node[:nova][:user_group]
  not_if {File.exists?("#{node[:nova][:user_dir]}/novarc")}
end

execute "cat #{node[:nova][:user_dir]}/novarc >> #{node[:nova][:user_dir]}/.bashrc" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/.bashrc")}
end

execute "ln -s #{node[:nova][:user_dir]}/.bashrc #{node[:nova][:user_dir]}/.profile" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/.profile")}
end

#for the euca2ools
execute "ln -s #{node[:nova][:user_dir]}/.bashrc #{node[:nova][:user_dir]}/.eucarc" do
  user node[:nova][:user]
  not_if {File.exists?("#{node[:nova][:user_dir]}/.eucarc")}
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

#debug output
# execute "nova-manage service list" do
#   user node[:nova][:user]
# end

#download and install AMIs
(node[:nova][:images] or []).each do |image|
  #get the filename of the image
  filename = image.split('/').last
  execute "uec-publish-tarball #{filename} nova_amis x86_64" do
    cwd "#{node[:nova][:user_dir]}/images/"
    #need EC2_URL, EC2_ACCESS_KEY, EC2_SECRET_KEY, EC2_CERT, EC2_PRIVATE_KEY, S3_URL, EUCALYPTUS_CERT for environment
    environment ({
                   'EC2_URL' => "http://#{node[:nova][:api]}:8773/services/Cloud",
                   'EC2_ACCESS_KEY' => node[:nova][:access_key],
                   'EC2_SECRET_KEY' => node[:nova][:secret_key],
                   'EC2_CERT_' => "#{node[:nova][:user_dir]}/cert.pem",
                   'EC2_PRIVATE_KEY_' => "#{node[:nova][:user_dir]}/pk.pem",
                   'S3_URL' => "http://#{node[:nova][:api]}:3333", #TODO need to put S3 into attributes instead of assuming API
                   'EUCALYPTUS_CERT' => "#{node[:nova][:user_dir]}/cacert.pem"
                 })
    user node[:nova][:user]
    action :nothing
  end
  remote_file image do
    source image
    path "#{node[:nova][:user_dir]}/images/#{filename}"
    owner node[:nova][:user]
    action :create_if_missing
    notifies :run, resources(:execute => "uec-publish-tarball #{filename} nova_amis x86_64"), :immediately
  end
end

# #debug output
# execute "euca-describe-images" do
#   user node[:nova][:user]
# end
