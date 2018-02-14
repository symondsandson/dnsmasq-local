# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local::centos::6_9' do
  include_context 'resources::dnsmasq_local::centos'

  let(:platform_version) { '6.9' }

  it_behaves_like 'any CentOS platform'
end
