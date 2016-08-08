# encoding: utf-8
# frozen_string_literal: true
require_relative '../../dnsmasq_local'

describe 'resources::dnsmasq_local::centos::6_8' do
  include_context 'resources::dnsmasq_local'

  let(:platform) { 'centos' }
  let(:platform_version) { '6.8' }

  it_behaves_like 'any platform'
end
