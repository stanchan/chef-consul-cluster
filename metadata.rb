name 'consul-cluster'
maintainer 'Stan Chan'
maintainer_email 'stanchan@gmail.com'
license 'Apache'
description 'Cookbook which installs and configures a Consul cluster.'
long_description 'Cookbook which installs and configures a Consul cluster.'
version '0.1.0'

supports 'centos', '>= 6.4'
supports 'redhat', '>= 6.4'
supports 'ubuntu', '>= 12.04'

depends 'ssl_certificate', '~> 1.11'
depends 'consul', '~> 2.1'
