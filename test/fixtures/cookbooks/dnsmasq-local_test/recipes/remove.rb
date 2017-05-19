# encoding: utf-8
# frozen_string_literal: true

include_recipe '::_prep'

dnsmasq_local_config '_default'
dnsmasq_local_app '_default'
dnsmasq_local_service '_default'

dnsmasq_local 'default' do
  action :remove
end
