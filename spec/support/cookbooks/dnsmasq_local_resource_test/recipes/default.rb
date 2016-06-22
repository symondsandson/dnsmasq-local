# Encoding: UTF-8

attrs = node['dnsmasq_local_resource_test']

send(attrs['resource'], attrs['name']) do
  attrs.each do |k, v|
    next if %w(resource name properties).include?(k.to_s)
    send(k, v)
  end
  attrs['properties'].to_h.each { |k, v| send(k, v) }
end
