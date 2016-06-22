# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_test']

dnsmasq_local attrs['name'] do
  config attrs['config'] unless attrs['config'].nil?
  environment attrs['environment'] unless attrs['environment'].nil?
  action attrs['action'] unless attrs['action'].nil?
end
