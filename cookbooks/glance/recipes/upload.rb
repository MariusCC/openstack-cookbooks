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

cookbook_file "#{node[:glance][:working_directory]}/glance-uploader.bash" do
  source "glance-uploader.bash"
  mode "0755"
end


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
  
  glance_upload = "#{node[:glance][:working_directory]}/glance-uploader.bash -h #{node.ipaddress}"
  glance_upload += " -a #{images[image]['arch']}"
  glance_upload += " -d #{images[image]['distro']}"
  glance_upload += " -e #{images[image]['kernel_version']}"
  glance_upload += " -i #{images[image]['image']}"
  glance_upload += " -k #{images[image]['kernel']}"
  glance_upload += " -v #{images[image]['version']}"

  execute glance_upload do
    cwd "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
    user node[:glance][:user]
    subscribes :run, resources(:execute => "tar -xf #{node[:glance][:working_directory]}/images/#{filename}"), :immediately
    action :nothing
  end
  
  directory "delete #{node[:glance][:working_directory]}/images/#{filename}-tmp" do
    path "#{node[:glance][:working_directory]}/images/#{filename}-tmp"
    subscribes :delete, resources(:execute => glance_upload)
    recursive true
    action :nothing
  end

end

