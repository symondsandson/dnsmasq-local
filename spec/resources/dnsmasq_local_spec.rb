# frozen_string_literal: true

require_relative '../resources'

describe 'resources::dnsmasq_local' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local' }
  %i[config options environment].each { |p| let(p) { nil } }
  let(:properties) do
    { config: config, options: options, environment: environment }
  end
  let(:name) { 'default' }

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  {
    config: { example: 'elpmaxe' },
    options: { example: 'elpmaxe' },
    environment: { 'EXAMPLE' => 'elpmaxe' }
  }.each do |k, v|
    shared_context "an overridden #{k} property" do
      let(k) { v }
    end
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates the dnsmasq_local_config' do
          expected = {
            config: {
              interface: '',
              cache_size: 0,
              no_hosts: true,
              bind_interfaces: true,
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
          expect(chef_run).to create_dnsmasq_local_service('default')
            .with(options.to_h.merge(environment: environment.to_h))
          expect(chef_run).to enable_dnsmasq_local_service('default')
          expect(chef_run).to start_dnsmasq_local_service('default')
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden config property' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden options property' do
        include_context description

        it_behaves_like 'any property set'
      end

      context 'an overridden environment property' do
        include_context description

        it_behaves_like 'any property set'
      end
    end

    context 'the :remove action' do
      include_context description

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

  RSpec.configuration.supported_platforms.each do |os, versions|
    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any platform'
        end
      end
    end
  end
end
