# encoding: utf-8
# frozen_string_literal: true

execute 'apt-get update' if node['platform_family'] == 'debian'

if %w(docker lxc).include?(node['virtualization']['system']) &&
   node['platform_family'] == 'debian'
  # Fake out the Docker build and its immutable resolv.conf.
  directory '/var/lib/resolvconf'
  file '/var/lib/resolvconf/linkified'

  package 'apt-utils'
  package 'resolvconf'

  service 'resolvconf' do
    action [:enable, :start]
  end
end

include_recipe 'dnsmasq-local'
