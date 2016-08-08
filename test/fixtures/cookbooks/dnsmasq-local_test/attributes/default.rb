# encoding: utf-8
# frozen_string_literal: true

if node['platform_family'] == 'rhel' && node['platform_version'].to_i < 7
  default['dnsmasq_local']['config']['proxy_dnssec'] = false
end
