# encoding: utf-8
# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local::centos::7_3_1611' do
  include_context 'resources::dnsmasq_local::centos'

  let(:platform_version) { '7.3.1611' }

  it_behaves_like 'any CentOS platform'
end
