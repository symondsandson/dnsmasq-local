# Encoding: UTF-8

# Fake out the Docker build and its immutable resolv.conf.
directory '/var/lib/resolvconf'
file '/var/lib/resolvconf/linkified'

%w(apt-utils resolvconf dnsutils).each { |p| package p }

service 'resolvconf' do
  status_command 'service resolvconf status'
  start_command 'service resolvconf start'
  action :start
end

include_recipe 'dnsmasq-local'
