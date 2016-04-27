# Encoding: UTF-8

dnsmasq_local 'default' do
  config node['dnsmasq_local']['config']
end
