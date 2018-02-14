# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local_config::centos::6_9' do
  include_context 'resources::dnsmasq_local_config::centos'

  let(:platform_version) { '6.9' }

  it_behaves_like 'any CentOS platform'
end
