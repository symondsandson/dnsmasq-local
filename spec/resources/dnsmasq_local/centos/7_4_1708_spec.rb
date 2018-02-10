# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local::centos::7_4_1708' do
  include_context 'resources::dnsmasq_local::centos'

  let(:platform_version) { '7.4.1708' }

  it_behaves_like 'any CentOS platform'
end
