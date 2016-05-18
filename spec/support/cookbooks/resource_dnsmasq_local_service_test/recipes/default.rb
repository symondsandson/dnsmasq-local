# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_service_test']

dnsmasq_local_service attrs['name'] do
  action attrs['action'] unless attrs['action'].nil?
end
