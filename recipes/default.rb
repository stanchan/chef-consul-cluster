#
# Cookbook Name:: consul-cluster
# Recipe:: default
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

if node['localdev']
  ipaddr = node['network']['interfaces']['ens33']['addresses'].keys[1]
else
  ipaddr = node['ipaddress']
end

node.override['consul'][node['consul']['version']]['archive_url'] = node['consul-cluster']['binary_url']

poise_service_user node['consul']['service_user'] do
  group node['consul']['service_group']
end

directory node['consul-cluster']['tls']['ssl_key']['root'] do
  recursive true
  owner node['consul']['service_user']
  group node['consul']['service_group']
end

directory node['consul-cluster']['tls']['ssl_cert']['root'] do
  recursive true
  owner node['consul']['service_user']
  group node['consul']['service_group']
end

directory node['consul-cluster']['tls']['ssl_chain']['root'] do
  recursive true
  owner node['consul']['service_user']
  group node['consul']['service_group']
end

certificate = ssl_certificate node['consul']['service_name'] do
  owner node['consul']['service_user']
  group node['consul']['service_group']
  namespace node['consul-cluster']['tls']
  notifies :reload, "consul_service[#{name}]", :delayed
end

node.default['consul']['config']['server'] = true
node.default['consul']['config']['verify_incoming'] = true
node.default['consul']['config']['verify_outgoing'] = true
node.default['consul']['config']['bind_addr'] = ipaddr
node.default['consul']['config']['advertise_addr'] = ipaddr
node.default['consul']['config']['advertise_addr_wan'] = ipaddr
node.default['consul']['config']['ca_file'] = certificate.chain_path
node.default['consul']['config']['cert_file'] = certificate.cert_path
node.default['consul']['config']['key_file'] = certificate.key_path

include_recipe 'chef-sugar::default'

if rhel?
  include_recipe 'yum-epel::default' if node['platform_version'].to_i == 5
end

node.default['nssm']['install_location'] = '%WINDIR%'

if node['firewall']['allow_consul']
  include_recipe 'firewall::default'

  # Don't open ports that we've disabled
  ports = node['consul']['config']['ports'].select { |_name, port| port != -1 }

  firewall_rule 'consul' do
    protocol :tcp
    port ports.values
    action :create
    command :allow
  end

  firewall_rule 'consul-udp' do
    protocol :udp
    port ports.values_at('serf_lan', 'serf_wan', 'dns')
    action :create
    command :allow
  end
end

unless windows?
  group node['consul']['service_group'] do
    system true
    
  end

  user node['consul']['service_user'] do
    shell '/bin/bash'
    group node['consul']['service_group']
    system true
  end
end

service_name = node['consul']['service_name']
config = consul_config service_name do |r|
  unless windows?
    owner node['consul']['service_user']
    group node['consul']['service_group']
  end
  node['consul']['config'].each_pair { |k, v| r.send(k, v) }
  notifies :reload, "consul_service[#{service_name}]", :delayed
end

consul_installation node['consul']['version'] do
  provider :webui
  version node['consul']['version']
  options symlink_to: config.ui_dir if config.ui_dir
  only_if { config.ui == true }
end

install = consul_installation node['consul']['version'] do |r|
  if node['consul']['installation']
    node['consul']['installation'].each_pair { |k, v| r.send(k, v) }
  end
end

consul_service service_name do |r|
  version node['consul']['version']
  config_file config.path
  program install.consul_program

  unless windows?
    user node['consul']['service_user']
    group node['consul']['service_group']
  end
  if node['consul']['service']
    node['consul']['service'].each_pair { |k, v| r.send(k, v) }
  end
end