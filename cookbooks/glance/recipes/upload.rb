#
# Cookbook Name:: glance
# Recipe:: upload
#
# Copyright 2011 Opscode, Inc.
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

#load in the AMIs
directory "#{node[:glance][:working_directory]}/images" do
  owner node[:glance][:user]
  mode 0755
end

#get the 'openstack' data bag 'images'['images'] list of hashes
images = data_bag_item('openstack', 'images')

(images.keys or []).each do |image|
  next if image == 'id'
  #get the filename of the image
  filename = image.split('/').last
  
  remote_file filename do
    source image
    path "#{node[:glance][:working_directory]}/images/#{filename}"
    owner node[:glance][:user]
    action :create_if_missing
    #notifies :create, resources(:directory => "#{node[:glance][:working_directory]}/images/#{filename}-tmp"), :immediately
  end

  #only run the following when the file is downloaded
  directory "#{node[:glance][:working_directory]}/images/#{filename}-tmp" do
    owner node[:glance][:user]
    subscribes :create, resources(:remote_file => filename), :immediately
    action :nothing
  end
  
  execute "tar -xf #{node[:glance][:working_directory]}/images/#{filename}" do
    cwd "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
    user node[:glance][:user]
    subscribes :run, resources(:directory => "#{node[:glance][:working_directory]}/images/#{filename}-tmp"), :immediately
    action :nothing
  end
  
  glance_command = "glance-upload --host=#{node.ipaddress} --disk-format=ami --container-format=ami --type=machine"
  glance_command += " --kernel=#{images[image]['kernel']}" if images[image]['kernel']
  glance_command += " --ramdisk=#{images[image]['ramdisk']}" if images[image]['ramdisk']
  glance_command += " #{images[image]['image']} #{images[image]['image']}"

  execute glance_command do
    cwd "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
    user node[:glance][:user]
    subscribes :run, resources(:execute => "tar -xf #{node[:glance][:working_directory]}/images/#{filename}"), :immediately
    action :nothing
  end
  
  glance_update = "glance update --host=#{node.ipaddress} #{images[image]['image']} type=machine uploader=#{node['glance']['user']}@#{node.fqdn}"
  glance_update += " arch=#{images[image]['arch']}" if images[image]['arch']
  glance_update += " distro=#{images[image]['distro']}" if images[image]['distro']
  glance_update += " version=#{images[image]['version']}" if images[image]['version']

  execute glance_update do
    command "echo #{glance_update}"
    cwd "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
    user node[:glance][:user]
    subscribes :run, resources(:execute => glance_command)
    action :nothing
  end

  # directory "delete #{node[:glance][:working_directory]}/images/#{filename}-tmp" do
  #   path "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
  #   subscribes :delete, resources(:execute => glance_update)
  #   recursive true
  #   action :nothing
  # end

end

