# encoding: utf-8
# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local_config::redhat::6_8' do
  include_context 'resources::dnsmasq_local_config::redhat'

  let(:platform_version) { '6.8' }

  it_behaves_like 'any Red Hat platform'
end
