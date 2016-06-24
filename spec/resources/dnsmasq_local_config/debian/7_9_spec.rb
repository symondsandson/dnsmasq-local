require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_config'

describe 'dnsmasq_local_config::debian::7_9' do
  include_context 'dnsmasq_local_config'

  let(:platform) { 'debian' }
  let(:platform_version) { '7.9' }

  context 'the default action (:create)' do
    include_context 'the default action (:create)'

    it_behaves_like 'any platform'
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any platform'
  end
end
