# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dnsmasq_local_service::debian::9.3' do
  include_context 'resources::dnsmasq_local_service::debian'

  let(:platform_version) { '9.3' }

  it_behaves_like 'any Debian platform'
end
