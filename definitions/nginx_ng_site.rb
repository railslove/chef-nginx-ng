#
# Cookbook Name:: nginx_ng
# Definition:: nginx_ng_site
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

define :nginx_ng_site, :enable => true do
  if params[:enable]
    execute "nxng_ensite #{params[:name]}" do
      command "ln -s #{node[:nginx_ng][:dir]}/sites-available/#{params[:name]} #{node[:nginx_ng][:dir]}/sites-enabled/#{params[:name]}"
      notifies :reload, resources(:service => "nginx")
      not_if do ::File.symlink?("#{node[:nginx_ng][:dir]}/sites-enabled/#{params[:name]}") end
    end
  else
    execute "nxng_dissite #{params[:name]}" do
      command "rm -rf #{node[:nginx_ng][:dir]}/sites-enabled/#{params[:name]}"
      notifies :reload, resources(:service => "nginx")
      only_if do ::File.symlink?("#{node[:nginx_ng][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end
end
