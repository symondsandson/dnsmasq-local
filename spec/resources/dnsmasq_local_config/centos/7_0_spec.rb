require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_config'

describe 'dnsmasq_local_config::centos::7_0' do
  include_context 'dnsmasq_local_config'

  let(:platform) { 'centos' }
  let(:platform_version) { '7.0' }

  context 'the default action (:create)' do
    include_context 'the default action (:create)'

    it_behaves_like 'any platform'
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any platform'
  end
end
