# frozen_string_literal: true

name 'dnsmasq-local'
maintainer 'Socrata Engineering'
maintainer_email 'sysadmin@socrata.com'
license 'Apache-2.0'
description 'Configures a local-only dnsmasq'
long_description 'Configures a local-only dnsmasq'
version '2.2.4'
chef_version '>= 12.1'

source_url 'https://github.com/socrata-cookbooks/dnsmasq-local'
issues_url 'https://github.com/socrata-cookbooks/dnsmasq-local/issues'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'
