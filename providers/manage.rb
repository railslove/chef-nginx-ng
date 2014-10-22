#
# Cookbook Name:: nginx_ng
# Provider:: manage
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

def environment_variables_for(site)
  Chef::EncryptedDataBagItem.load(new_resource.variables_data_bag, site[:id])
rescue ArgumentError
  Chef::Log.info("attempting to load environment_variables for #{site[:id]} but cannot decrypt")
  nil
rescue Net::HTTPServerException
  Chef::Log.debug("no environment_variables for #{site[:id]}. but thats totally ok!")
  nil
end

action :remove do
  query = "NOT (#{node[:roles].map{|r| "roles:#{r}" }.join(" OR ")})"
  Chef::Log.info("Running query: #{query}")
  search("#{new_resource.data_bag}", "#{query}") do |site|
    nginx_ng_site "#{site['id']}.conf" do
      enable false
    end
    execute "rm -rf #{node[:nginx_ng][:dir]}/sites-available/#{site['id']}.conf"
  end
end

action :create do
  query = "(#{node[:roles].map{|r| "roles:#{r}" }.join(" OR ")})"
  Chef::Log.info("Running query: #{query}")

  search("#{new_resource.data_bag}", "#{query}") do |item|
    site = Chef::Mixin::DeepMerge.merge(item.to_hash, (item[node.chef_environment] || {}))

    next if site['server_names'].empty?

    environment_variables = environment_variables_for(site)
    cert = site['certificate'] ? search("#{new_resource.certificate_data_bag}", "id:#{site['certificate']}").first : nil
    nginx_ng_web_app site['id'] do
      application site
      certificate cert
      environment_variables environment_variables
      if site['server']
        template "default-site-#{site['server']}.conf.erb"
      end
    end
  end
end
