require_relative '../spec_helper'

describe 'dnsmasq_local' do
  let(:resource) { 'dnsmasq_local' }
  let(:name) { 'default' }
  %i(platform platform_version config environment action).each do |p|
    let(p) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: resource, platform: platform, version: platform_version
    ) do |node|
      %i(resource name config environment action).each do |p|
        unless send(p).nil?
          node.default['dnsmasq_local_resource_test'][p] = send(p)
        end
      end
    end
  end
  let(:converge) { runner.converge('dnsmasq_local_resource_test') }

  context 'the default action (:create)' do
    let(:action) { nil }

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }

      context '16.04' do
        let(:platform_version) { '16.04' }

        shared_examples_for 'any attribute set' do
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
            }.merge(config.to_h)
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
            }.merge(environment.to_h)
            expect(chef_run).to create_dnsmasq_local_service('default')
              .with(expected)
            expect(chef_run).to enable_dnsmasq_local_service('default')
            expect(chef_run).to start_dnsmasq_local_service('default')
          end
        end

        context 'the default attributes' do
          let(:config) { nil }
          cached(:chef_run) { converge }

          it_behaves_like 'any attribute set'
        end

        context 'a config attribute' do
          let(:config) { { example: 'elpmaxe' } }
          cached(:chef_run) { converge }

          it_behaves_like 'any attribute set'
        end

        context 'an environment attribute' do
          let(:environment) { { example: 'elpmaxe' } }
          cached(:chef_run) { converge }

          it_behaves_like 'any attribute set'
        end
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }

      context '16.04' do
        let(:platform_version) { '16.04' }
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
end
