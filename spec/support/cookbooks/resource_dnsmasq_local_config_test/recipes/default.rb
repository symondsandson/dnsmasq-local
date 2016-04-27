# Encoding: UTF-8

override_config = node['dnsmasq_local']['override_config']
merge_configs = node['dnsmasq_local']['merge_configs']

dnsmasq_local_config 'default' do
  config override_config unless override_config.nil?
  merge_configs.to_h.each { |k, v| send(k, v) }
end
