# encoding: utf-8
# frozen_string_literal: true

name 'dnsmasq-local'
maintainer 'Jonathan Hartman'
maintainer_email 'jonathan.hartman@socrata.com'
license 'apache2'
description 'Configures a local-only dnsmasq'
long_description 'Configures a local-only dnsmasq'
version '1.1.1'
chef_version '>= 12'

source_url 'https://github.com/socrata-cookbooks/dnsmasq-local'
issues_url 'https://github.com/socrata-cookbooks/dnsmasq-local/issues'

supports 'ubuntu'
supports 'debian'
supports 'redhat'
supports 'centos'
supports 'scientific'

conflicts 'dnsmasq'
