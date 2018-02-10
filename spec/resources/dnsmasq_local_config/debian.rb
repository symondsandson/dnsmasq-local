# frozen_string_literal: true

require_relative '../dnsmasq_local_config'

shared_context 'resources::dnsmasq_local_config::debian' do
  include_context 'resources::dnsmasq_local_config'

  let(:platform) { 'debian' }

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'
  end
end
