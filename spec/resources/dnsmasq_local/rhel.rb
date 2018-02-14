# frozen_string_literal: true

require_relative '../dnsmasq_local'

shared_context 'resources::dnsmasq_local::rhel' do
  include_context 'resources::dnsmasq_local'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'
  end
end
