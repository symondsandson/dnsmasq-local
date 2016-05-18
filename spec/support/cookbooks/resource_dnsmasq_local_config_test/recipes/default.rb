# Encoding: UTF-8

attrs = node['resource_dnsmasq_local_config_test']

dnsmasq_local_config attrs['name'] do
  config attrs['config'] unless attrs['config'].nil?
  attrs['properties'].to_h.each { |k, v| send(k, v) }
  action attrs['action'] unless attrs['action'].nil?
end
