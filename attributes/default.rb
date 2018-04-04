#
# Cookbook Name:: consul-cluster
# Attributes:: default
#
# Copyright (C) 2017 Stan Chan
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

default['consul-cluster']['tls']['ssl_key']['source'] = 'data-bag'
default['consul-cluster']['tls']['ssl_key']['bag'] = 'secrets'
default['consul-cluster']['tls']['ssl_key']['item'] = 'consul'
default['consul-cluster']['tls']['ssl_key']['item_key'] = 'private_key'
default['consul-cluster']['tls']['ssl_key']['encrypted'] = false
default['consul-cluster']['tls']['ssl_key']['root'] = join_path config_prefix_path, 'ssl', 'private'
default['consul-cluster']['tls']['ssl_key']['path'] = join_path node['consul-cluster']['tls']['ssl_key']['root'], 'consul.key'

default['consul-cluster']['tls']['ssl_cert']['source'] = 'data-bag'
default['consul-cluster']['tls']['ssl_cert']['bag'] = 'secrets'
default['consul-cluster']['tls']['ssl_cert']['item'] = 'consul'
default['consul-cluster']['tls']['ssl_cert']['item_key'] = 'certificate'
default['consul-cluster']['tls']['ssl_cert']['encrypted'] = false
default['consul-cluster']['tls']['ssl_cert']['root'] = join_path config_prefix_path, 'ssl', 'certs'
default['consul-cluster']['tls']['ssl_cert']['path'] = join_path node['consul-cluster']['tls']['ssl_cert']['root'], 'consul.crt'

default['consul-cluster']['tls']['ssl_chain']['name'] = 'ca.crt'
default['consul-cluster']['tls']['ssl_chain']['source'] = 'data-bag'
default['consul-cluster']['tls']['ssl_chain']['bag'] = 'secrets'
default['consul-cluster']['tls']['ssl_chain']['item'] = 'consul'
default['consul-cluster']['tls']['ssl_chain']['item_key'] = 'ca'
default['consul-cluster']['tls']['ssl_chain']['encrypted'] = false
default['consul-cluster']['tls']['ssl_chain']['root'] = join_path config_prefix_path, 'ssl', 'certs'
default['consul-cluster']['tls']['ssl_chain']['path'] = join_path node['consul-cluster']['tls']['ssl_chain']['root'], 'ca.crt'

default['consul-cluster']['base_url'] = 'https://releases.hashicorp.com/consul'
default['consul-cluster']['binary_url'] = "#{node['consul-cluster']['base_url']}/%{basename}" # rubocop:disable Style/StringLiterals
default['consul-cluster']['ui'] = true