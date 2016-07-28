# encoding: utf-8
# frozen_string_literal: true
require_relative '../rhel'

describe 'resources::dnsmasq_local_app::redhat::7_1' do
  include_context 'resources::dnsmasq_local_app::rhel'

  let(:platform) { 'redhat' }
  let(:platform_version) { '7.1' }

  it_behaves_like 'any RHEL platform'
end
