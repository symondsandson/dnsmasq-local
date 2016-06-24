require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local'

describe 'dnsmasq_local::debian::8_4' do
  include_context 'dnsmasq_local'

  let(:platform) { 'debian' }
  let(:platform_version) { '8.4' }

  context 'the default action (:create)' do
    include_context 'the default action (:create)'

    it_behaves_like 'any platform'
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any platform'
  end
end
