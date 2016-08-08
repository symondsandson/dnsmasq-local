# encoding: utf-8
# frozen_string_literal: true
require_relative '../../dnsmasq_local_config'

describe 'resources::dnsmasq_local_config::centos::7_2_1511' do
  include_context 'resources::dnsmasq_local_config'

  let(:platform) { 'centos' }
  let(:platform_version) { '7.2.1511' }

  it_behaves_like 'any platform'
end
