# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dnsmasq_local_service::debian::7_9' do
  include_context 'resources::dnsmasq_local_service::debian'

  let(:platform) { 'debian' }
  let(:platform_version) { '7.9' }

  it_behaves_like 'any Debian platform'
end
