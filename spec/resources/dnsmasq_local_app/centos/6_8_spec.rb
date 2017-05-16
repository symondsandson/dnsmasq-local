# encoding: utf-8
# frozen_string_literal: true

require_relative '../centos'

describe 'resources::dnsmasq_local_app::centos::6_8' do
  include_context 'resources::dnsmasq_local_app::centos'

  let(:platform_version) { '6.8' }

  it_behaves_like 'any CentOS platform'

  context 'the :remove action' do
    include_context description

    it 'removes the dnsmasq package via rpm' do
      expect(chef_run).to remove_rpm_package('dnsmasq')
        .with(options: %w[--noscripts])
    end
  end
end
