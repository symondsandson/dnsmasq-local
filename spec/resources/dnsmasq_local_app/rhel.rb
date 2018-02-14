# frozen_string_literal: true

require_relative '../dnsmasq_local_app'

shared_context 'resources::dnsmasq_local_app::rhel' do
  include_context 'resources::dnsmasq_local_app'

  shared_examples_for 'any RHEL platform' do
    it_behaves_like 'any platform'
  end
end
