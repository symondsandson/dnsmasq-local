# frozen_string_literal: true

include_recipe '::_prep'

dnsmasq_local_config 'default'
dnsmasq_local_app 'default'
dnsmasq_local_service 'default'

dnsmasq_local 'default' do
  action :remove
end
