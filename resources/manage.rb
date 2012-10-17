#
# Cookbook Name:: nginx_ng
# Resources:: manage
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

# Data bag application object needs a "roles": ["<some_role>"] tag, that
# matches one of the node's roles to actually be added by the action.
actions :create, :remove

# :data_bag is the object to search
# :certificate_data_bag is the object to look for certificates
# :cookbook is the name of the cookbook that the authorized_keys template should be found in
attribute :data_bag, :kind_of => String, :default => "applications"
attribute :certificate_data_bag, :kind_of => String, :default => "certificates"
attribute :cookbook, :kind_of => String, :default => "nginx_ng"
attribute :site,     :kind_of => String, :name_attribute => true

def initialize(*args)
  super
  @action = :create
end