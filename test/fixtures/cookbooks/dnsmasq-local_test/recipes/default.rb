# Encoding: UTF-8

# Fake out the Docker build and its immutable resolv.conf.
directory '/var/lib/resolvconf'
file '/var/lib/resolvconf/linkified'

include_recipe 'apt'
%w(apt-utils resolvconf).each { |p| package p }

service 'resolvconf' do
  action [:enable, :start]
end

include_recipe 'dnsmasq-local'
