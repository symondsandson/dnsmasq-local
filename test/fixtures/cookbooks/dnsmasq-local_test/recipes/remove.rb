# encoding: utf-8
# frozen_string_literal: true

include_recipe '::default'

dnsmasq_local 'default' do
  action :remove
end
