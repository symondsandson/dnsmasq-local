# frozen_string_literal: true

require_relative '../debian'

describe 'resources::dnsmasq_local_app::debian::9_3' do
  include_context 'resources::dnsmasq_local_app::debian'

  let(:platform_version) { '9.3' }

  it_behaves_like 'any Debian platform'
end
