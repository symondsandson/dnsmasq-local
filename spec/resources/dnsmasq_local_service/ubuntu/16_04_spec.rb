# frozen_string_literal: true

require_relative '../ubuntu'

describe 'resources::dnsmasq_local_service::ubuntu::16_04' do
  include_context 'resources::dnsmasq_local_service::ubuntu'

  let(:platform_version) { '16.04' }

  it_behaves_like 'any Ubuntu platform'
end
