# frozen_string_literal: true

require_relative '../dnsmasq_local_service'

shared_context 'resources::dnsmasq_local_service::sysvinit' do
  include_context 'resources::dnsmasq_local_service'

  before do
    allow(Chef::Platform::ServiceHelpers)
      .to receive(:service_resource_providers).and_return(%i[upstart])
  end

  shared_examples_for 'any Sysvinit platform' do
    it_behaves_like 'any platform'
  end
end
