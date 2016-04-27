# Encoding: UTF-8

source 'https://supermarket.chef.io'

metadata

group :unit do
  cookbook 'resource_dnsmasq_local_test',
           path: 'spec/support/cookbooks/resource_dnsmasq_local_test'
  cookbook 'resource_dnsmasq_local_app_test',
           path: 'spec/support/cookbooks/resource_dnsmasq_local_app_test'
  cookbook 'resource_dnsmasq_local_config_test',
           path: 'spec/support/cookbooks/resource_dnsmasq_local_config_test'
  cookbook 'resource_dnsmasq_local_service_test',
           path: 'spec/support/cookbooks/resource_dnsmasq_local_service_test'
end

group :integration do
  cookbook 'dnsmasq-local_test',
           path: 'test/fixtures/cookbooks/dnsmasq-local_test'
end
