#
# Cookbook Name:: nginx_ng
# Recipe:: default
#
# Copyright 2012, Railslove GmbH
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

package "python-software-properties"

if platform?('ubuntu')
  apt_repository 'ruby-ng' do
    uri 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu'
    components ['main']
    distribution node['lsb']['codename']
    key 'C3173AA6'
    keyserver 'keyserver.ubuntu.com'
    action :add
  end
end

if node[:passenger][:ruby_version].to_s =~ /^2\./
  package "nginx-extras"
else
  package "nginx-full"
end

execute "remove default site" do
  command "rm -rf #{node[:nginx_ng][:dir]}/sites-enabled/default"
  only_if { ::File.symlink?("#{node[:nginx_ng][:dir]}/sites-enabled/default") }
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/nginx/conf.d/log.conf" do
  source "log.conf.erb"
  notifies :reload, resources(:service => "nginx"), :delayed
  only_if { node[:nginx_ng][:log_formats].any? }
end
