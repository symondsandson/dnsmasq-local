# encoding: utf-8
# frozen_string_literal: true

require_relative '../ubuntu'

describe 'resources::dnsmasq_local_app::ubuntu::16_04' do
  include_context 'resources::dnsmasq_local_app::ubuntu'

  let(:platform_version) { '16.04' }

  it_behaves_like 'any Ubuntu platform'
end
