# encoding: utf-8
# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local_app::redhat::7_3' do
  include_context 'resources::dnsmasq_local_app::redhat'

  let(:platform_version) { '7.3' }

  it_behaves_like 'any Red Hat platform'

  context 'the :remove action' do
    include_context description

    it 'removes the dnsmasq package via yum' do
      expect(chef_run).to remove_package('dnsmasq')
        .with(options: nil)
    end
  end
end
