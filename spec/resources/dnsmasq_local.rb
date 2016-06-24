require_relative '../spec_helper'
require_relative '../resources'

shared_context 'dnsmasq_local' do
  include_context 'any custom resource'

  let(:resource) { 'dnsmasq_local' }
  let(:properties) { { config: nil, environment: nil } }
  let(:name) { 'default' }

  shared_context 'the default action (:create)' do
    shared_examples_for 'any platform' do
      shared_examples_for 'any attributes' do
        it 'creates the dnsmasq_local_config' do
          expected = {
            config: {
              interface: '',
              cache_size: 0,
              no_hosts: true,
              bind_interfaces: true,
              proxy_dnssec: true,
              query_port: 0
            }
          }.merge(properties[:config].to_h)
          expect(chef_run).to create_dnsmasq_local_config('default')
            .with(expected)
          expect(chef_run.dnsmasq_local_config('default'))
            .to notify('dnsmasq_local_service[default]').to(:restart)
        end

        it 'installs the dnsmasq_local_app' do
          expect(chef_run).to install_dnsmasq_local_app('default')
          expect(chef_run.dnsmasq_local_app('default'))
            .to notify('dnsmasq_local_service[default]').to(:restart)
        end

        it 'creates, enables, and starts the dnsmasq_local_service' do
          expected = {
            environment: {
              config_dir: '/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new',
              enabled: 1
            }
          }.merge(properties[:environment].to_h)
          expect(chef_run).to create_dnsmasq_local_service('default')
            .with(expected)
          expect(chef_run).to enable_dnsmasq_local_service('default')
          expect(chef_run).to start_dnsmasq_local_service('default')
        end
      end

      context 'the default attributes' do
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'
      end

      context 'a config attribute' do
        let(:properties) { { config: { example: 'elpmaxe' } } }
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'
      end

      context 'an environment attribute' do
        let(:properties) { { environment: { example: 'elpmaxe' } } }
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'
      end
    end
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }

    shared_examples_for 'any platform' do
      cached(:chef_run) { converge }

      it 'stops, disables, and removes the dnsmasq_local_service' do
        expect(chef_run).to stop_dnsmasq_local_service('default')
        expect(chef_run).to disable_dnsmasq_local_service('default')
        expect(chef_run).to remove_dnsmasq_local_service('default')
      end

      it 'removes the dnsmasq_local_config' do
        expect(chef_run).to remove_dnsmasq_local_config('default')
      end

      it 'removes the dnsmasq_local_app' do
        expect(chef_run).to remove_dnsmasq_local_app('default')
      end
    end
  end
end
