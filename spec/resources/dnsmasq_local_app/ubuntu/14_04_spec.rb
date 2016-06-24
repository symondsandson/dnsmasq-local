require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_app'

describe 'dnsmasq_local_app::ubuntu::14_04' do
  include_context 'dnsmasq_local_app'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  context 'the default action (:install)' do
    include_context 'the default action (:install)'

    it_behaves_like 'any platform'
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any Debian platform'
  end
end
