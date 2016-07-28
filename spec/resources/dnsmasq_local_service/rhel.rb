# encoding: utf-8
# frozen_string_literal: true

require_relative '../dnsmasq_local_service'

shared_context 'resources::dnsmasq_local_service::rhel' do
  include_context 'resources::dnsmasq_local_service'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'
  end
end
