# frozen_string_literal: true

node.normal['dnsmasq_local']['config'].tap do |c|
  c['bind_interfaces'] = false
  c['cache_size'] = 64
  c['server'] = %w[8.8.8.8 8.8.4.4]
  c['address'] = '/example.biz/127.0.0.1'
end

node.normal['dnsmasq_local']['options'].tap do |o|
  o['all_servers'] = true
  o['bad_option'] =  false
end

node.normal['dnsmasq_local']['environment']['FAKE'] = 'certainly'

include_recipe '::default'
