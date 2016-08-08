# encoding: utf-8
# frozen_string_literal: true
require_relative '../resources'

shared_context 'resources::dnsmasq_local' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local' }
  %i(config options).each { |p| let(p) { nil } }
  let(:properties) { { config: config, options: options } }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:create)' do
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
          expect(chef_run).to create_dnsmasq_local_service('default')
            .with(options.to_h)
          expect(chef_run).to enable_dnsmasq_local_service('default')
          expect(chef_run).to start_dnsmasq_local_service('default')
        end
      end

      context 'the default attributes' do
        it_behaves_like 'any attribute set'
      end

      context 'a config attribute' do
        let(:config) { { example: 'elpmaxe' } }

        it_behaves_like 'any attribute set'
      end

      context 'an options attribute' do
        let(:options) { { example: 'elpmaxe' } }

        it_behaves_like 'any attribute set'
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }

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
