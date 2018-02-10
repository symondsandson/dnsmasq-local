# frozen_string_literal: true

source 'https://supermarket.chef.io'

metadata

group :unit do
  cookbook 'resource_test', path: 'spec/support/cookbooks/resource_test'
end

group :integration do
  cookbook 'dnsmasq-local_test',
           path: 'test/fixtures/cookbooks/dnsmasq-local_test'
end
