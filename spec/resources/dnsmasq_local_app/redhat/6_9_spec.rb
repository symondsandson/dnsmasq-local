# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local_app::redhat::6_9' do
  include_context 'resources::dnsmasq_local_app::redhat'

  let(:platform_version) { '6.9' }

  it_behaves_like 'any Red Hat platform'

  context 'the :remove action' do
    include_context description

    it 'removes the dnsmasq package via rpm' do
      expect(chef_run).to remove_rpm_package('dnsmasq')
        .with(options: %w[--noscripts])
    end
  end
end
