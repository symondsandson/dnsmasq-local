# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local_app::centos::7_4_1708' do
  include_context 'resources::dnsmasq_local_app::centos'

  let(:platform_version) { '7.4.1708' }

  it_behaves_like 'any CentOS platform'

  context 'the :remove action' do
    include_context description

    it 'removes the dnsmasq package via yum' do
      expect(chef_run).to remove_package('dnsmasq')
        .with(options: nil)
    end
  end
end
