# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_service_test']

dnsmasq_local_service attrs['name'] do
  environment attrs['environment'] unless attrs['environment'].nil?
  attrs['properties'].to_h.each { |k, v| send(k, v) }
  action attrs['action'] unless attrs['action'].nil?
end
