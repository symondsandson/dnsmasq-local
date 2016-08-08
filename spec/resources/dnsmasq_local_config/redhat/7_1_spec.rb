# encoding: utf-8
# frozen_string_literal: true
require_relative '../../dnsmasq_local_config'

describe 'resources::dnsmasq_local_config::redhat::7_1' do
  include_context 'resources::dnsmasq_local_config'

  let(:platform) { 'redhat' }
  let(:platform_version) { '7.1' }

  it_behaves_like 'any platform'
end
