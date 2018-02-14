# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local_config::centos::7_4_1708' do
  include_context 'resources::dnsmasq_local_config::centos'

  let(:platform_version) { '7.4.1708' }

  it_behaves_like 'any CentOS platform'
end
