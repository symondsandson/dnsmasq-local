# encoding: utf-8
# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local_config::redhat::7_3' do
  include_context 'resources::dnsmasq_local_config::redhat'

  let(:platform_version) { '7.3' }

  it_behaves_like 'any Red Hat platform'
end