# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local::redhat::7_4' do
  include_context 'resources::dnsmasq_local::redhat'

  let(:platform_version) { '7.4' }

  it_behaves_like 'any Red Hat platform'
end