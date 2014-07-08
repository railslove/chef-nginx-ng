#
# Cookbook Name:: nginx_ng
# Provider:: reverse_proxy
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

def initialize(*args)
  super
  @action = :create
end

action :remove do
  query = "NOT (#{node[:roles].map{|r| "proxy_roles:#{r}" }.join(" OR ")})"
  Chef::Log.info("Running query: #{query}")
  search("#{new_resource.data_bag}", "#{query}") do |site|
    nginx_ng_site "#{site['id']}_proxy.conf" do
      enable false
    end
    execute "rm -rf #{node[:nginx_ng][:dir]}/sites-available/#{site['id']}_proxy.conf"
  end
end

action :create do
  query = "(#{node[:roles].map{|r| "proxy_roles:#{r}" }.join(" OR ")})"
  Chef::Log.info("Running query: #{query}")

  Chef::Log.warn("!!!! #{new_resource.cookbook} - #{new_resource.cookbook.class}")

  search("#{new_resource.data_bag}", "#{query}") do |item|
    site = Chef::Mixin::DeepMerge.merge(item.to_hash, (item[node.chef_environment] || {}))
    query = "(#{site[:proxy_roles].map{|r| "roles:#{r}" }.join(" OR ")})"
    nodes = search(:node, "#{query}").to_a
    cert = site['certificate'] ? search("#{new_resource.certificate_data_bag}", "id:#{site['certificate']}").first : nil
    Chef::Log.info("Found #{nodes.count} nodes!")
    nginx_ng_web_app "#{site['id']}_proxy" do
      application site
      external site['externals']['reverse_proxy']
      hosts nodes
      certificate cert
      template "default-site-proxy.conf.erb"
    end
  end
end
