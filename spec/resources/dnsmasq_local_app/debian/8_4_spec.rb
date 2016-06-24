require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_app'

describe 'dnsmasq_local_app::debian::8_4' do
  include_context 'dnsmasq_local_app'

  let(:platform) { 'debian' }
  let(:platform_version) { '8.4' }

  context 'the default action (:install)' do
    include_context 'the default action (:install)'

    it_behaves_like 'any platform'
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any Debian platform'
  end
end
