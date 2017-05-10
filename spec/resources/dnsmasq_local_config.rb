# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::dnsmasq_local_config' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_config' }
  %i(config).each { |p| let(p) { nil } }
  let(:properties) { { config: config } }
  let(:name) { 'default' }

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden config property' do
    let(:config) do
      {
        interface: 'docker0',
        no_hosts: false,
        example: 'elpmaxe',
        bool: true,
        other_bool: false
      }
    end
  end

  shared_context 'some extra properties' do
    let(:properties) do
      {
        interface: 'docker0',
        no_hosts: false,
        example: 'elpmaxe',
        server: %w(8.8.8.8 8.8.4.4),
        bool: true,
        other_bool: false
      }
    end
  end

  shared_context 'an invalid config property' do
    let(:config) { { example: :bad } }
  end

  shared_examples_for 'any platform' do
    context 'the :create action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'creates the main dnsmasq.conf file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            conf-dir=/etc/dnsmasq.d
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.conf')
            .with(content: expected)
        end

        it 'creates the dnsmasq.d directory' do
          expect(chef_run).to create_directory('/etc/dnsmasq.d')
        end
      end

      context 'all default properties' do
        include_context description

        it_behaves_like 'any property set'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            cache-size=0
            interface=
            no-hosts
            query-port=0
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'an overridden config property' do
        include_context description

        it_behaves_like 'any property set'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bool
            example=elpmaxe
            interface=docker0
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'some extra properties' do
        include_context description

        it_behaves_like 'any property set'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            bool
            cache-size=0
            example=elpmaxe
            interface=docker0
            query-port=0
            server=8.8.8.8
            server=8.8.4.4
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'an invalid config property' do
        include_context description

        it 'raises an error' do
          expected = Chef::Exceptions::ValidationFailed
          expect { chef_run }.to raise_error(expected)
        end
      end
    end
  end

  context 'the :remove action' do
    include_context description

    it 'deletes the dnsmasq.d directory' do
      expect(chef_run).to delete_directory('/etc/dnsmasq.d')
        .with(recursive: true)
    end
  end
end
