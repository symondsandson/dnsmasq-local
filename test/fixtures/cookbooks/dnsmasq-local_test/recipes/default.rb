# Encoding: UTF-8

execute 'apt-get update'

if %w(docker lxc).include?(node['virtualization']['system'])
  # Fake out the Docker build and its immutable resolv.conf.
  directory '/var/lib/resolvconf'
  file '/var/lib/resolvconf/linkified'

  %w(apt-utils resolvconf).each { |p| package p }

  service 'resolvconf' do
    action [:enable, :start]
  end
end

include_recipe 'dnsmasq-local'
