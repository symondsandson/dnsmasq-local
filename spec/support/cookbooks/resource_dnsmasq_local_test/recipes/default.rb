# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_test']

dnsmasq_local attrs['name'] do
  config attrs['config'] unless attrs['config'].nil?
  action attrs['action'] unless attrs['action'].nil?
end
