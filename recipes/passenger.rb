#
# Cookbook Name:: nginx_ng
# Recipe:: passenger
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
include_recipe "nginx_ng"

if node[:passenger][:ruby_version].to_s =~ /^1\.9/
  package "passenger-common1.9.1"
end

if node[:passenger][:ruby_version].to_s =~ /^2\./
  node.set[:passenger][:root] = "/usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini"
  package "passenger"
end

template "/etc/nginx/conf.d/passenger.conf" do
  source "passenger.conf.erb"
  notifies :restart, resources(:service => "nginx"), :delayed
end
