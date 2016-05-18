# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_app_test']

dnsmasq_local_app attrs['name'] do
  action attrs['action'] unless attrs['action'].nil?
end
