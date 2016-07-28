# encoding: utf-8
# frozen_string_literal: true
require_relative '../debian'

describe 'resources::dnsmasq_local_app::ubuntu::14_04' do
  include_context 'resources::dnsmasq_local_app::debian'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  it_behaves_like 'any Debian platform'
end
