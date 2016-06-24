require_relative '../spec_helper'
require_relative '../resources'

shared_context 'dnsmasq_local_config' do
  include_context 'any custom resource'

  let(:resource) { 'dnsmasq_local_config' }
  let(:properties) { { config: nil } }
  let(:name) { 'default' }

  shared_context 'the default action (:create)' do
    shared_examples_for 'any platform' do
      shared_examples_for 'any attributes' do
        it 'creates the dnsmasq.d directory' do
          expect(chef_run).to create_directory('/etc/dnsmasq.d')
        end
      end

      context 'the default attributes' do
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            cache-size=0
            interface=
            no-hosts
            proxy-dnssec
            query-port=0
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'a default config override' do
        let(:properties) do
          {
            config: {
              interface: 'docker0',
              no_hosts: false,
              example: 'elpmaxe',
              bool: true,
              other_bool: false
            }
          }
        end
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'

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

      context 'some extra configs to merge in with the default' do
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
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            bool
            cache-size=0
            example=elpmaxe
            interface=docker0
            proxy-dnssec
            query-port=0
            server=8.8.8.8
            server=8.8.4.4
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'an invalid config attribute' do
        let(:properties) { { config: { example: :bad } } }
        cached(:chef_run) { converge }

        it 'raises an error' do
          expected = Chef::Exceptions::ValidationFailed
          expect { chef_run }.to raise_error(expected)
        end
      end
      context 'a default config override' do
        let(:properties) do
          {
            config: {
              interface: 'docker0',
              no_hosts: false,
              example: 'elpmaxe',
              bool: true,
              other_bool: false
            }
          }
        end
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'

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

      context 'some extra configs to merge in with the default' do
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
        cached(:chef_run) { converge }

        it_behaves_like 'any attributes'

        it 'generates the expected config' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            bool
            cache-size=0
            example=elpmaxe
            interface=docker0
            proxy-dnssec
            query-port=0
            server=8.8.8.8
            server=8.8.4.4
          EOH
          expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
            .with(content: expected)
        end
      end

      context 'an invalid config attribute' do
        let(:properties) { { config: { example: :bad } } }
        cached(:chef_run) { converge }

        it 'raises an error' do
          expected = Chef::Exceptions::ValidationFailed
          expect { chef_run }.to raise_error(expected)
        end
      end
    end
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }

    shared_examples_for 'any platform' do
      cached(:chef_run) { converge }

      it 'deletes the dnsmasq.d directory' do
        expect(chef_run).to delete_directory('/etc/dnsmasq.d')
          .with(recursive: true)
      end
    end
  end
end
