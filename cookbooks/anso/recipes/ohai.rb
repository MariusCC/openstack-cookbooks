#
# Cookbook Name:: anso
# Recipe:: settings
#
# Copyright 2011, Anso Labs
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

%w{ruby ruby-dev libruby ri build-essential wget ssl-cert
git}.each do | pkg |
  package pkg
end

file "/root/ohai.sh" do
  content <<-EOH
cd /root
wget -nc http://production.cf.rubygems.org/rubygems/rubygems-1.3.7.tgz
tar zxf rubygems-1.3.7.tgz
cd rubygems-1.3.7
ruby setup.rb --no-format-executable
gem install --no-rdoc --no-ri gemcutter jeweler rake chef
gem install rspec -v 1.3.1
cd /root
git clone git://github.com/opscode/ohai.git
git clone git://github.com/opscode/mixlib-authentication.git
git clone git://github.com/opscode/mixlib-config.git
git clone git://github.com/opscode/mixlib-log.git
git clone git://github.com/opscode/mixlib-cli.git
for mixlib in config cli log authentication
do
  pushd mixlib-$mixlib
  rake install
  popd
done
cd /root/ohai
rake install
EOH
  owner "root"
  group "root"
end

execute "bash /root/ohai.sh && touch /root/installed" do
  user "root"
  group "root"
  not_if { File.exists?("/root/installed") }
end
