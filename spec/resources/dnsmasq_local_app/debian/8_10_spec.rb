# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dnsmasq_local_app::debian::8_10' do
  include_context 'resources::dnsmasq_local_app::debian'

  let(:platform_version) { '8.10' }

  it_behaves_like 'any Debian platform'
end
