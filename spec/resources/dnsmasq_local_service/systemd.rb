# frozen_string_literal: true

require_relative '../dnsmasq_local_service'

shared_context 'resources::dnsmasq_local_service::systemd' do
  include_context 'resources::dnsmasq_local_service'

  before do
    allow(Chef::Platform::ServiceHelpers)
      .to receive(:service_resource_providers).and_return(%i[systemd upstart])
  end

  shared_examples_for 'any Systemd platform' do
    it_behaves_like 'any platform'

    context 'the :enable action' do
      include_context description

      context 'systemd-resolved installed' do
        before do
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?)
            .with('/lib/systemd/system/systemd-resolved.service')
            .and_return(true)
        end

        it 'stops systemd-resolved' do
          expect(chef_run).to stop_service('systemd-resolved')
        end

        it 'disables systemd-resolved' do
          expect(chef_run).to disable_service('systemd-resolved')
        end
      end

      context 'systemd-resolved not installed' do
        before do
          allow(File).to receive(:exist?).and_call_original
          allow(File).to receive(:exist?)
            .with('/lib/systemd/system/systemd-resolved.service')
            .and_return(false)
        end

        it 'does not stop systemd-resolved' do
          expect(chef_run).to_not stop_service('systemd-resolved')
        end

        it 'does not disable systemd-resolved' do
          expect(chef_run).to_not disable_service('systemd-resolved')
        end
      end
    end
  end
end
