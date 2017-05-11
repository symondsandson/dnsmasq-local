# encoding: utf-8
# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dnsmasq_local_app::debian::8_7' do
  include_context 'resources::dnsmasq_local_app::debian'

  let(:platform_version) { '8.7' }

  it_behaves_like 'any Debian platform'
end
