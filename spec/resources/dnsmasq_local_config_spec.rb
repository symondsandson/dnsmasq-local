require_relative '../spec_helper'

describe 'dnsmasq_local_config' do
  let(:resource) { 'dnsmasq_local_config' }
  let(:name) { 'default' }
  %i(platform platform_version config properties action).each do |p|
    let(p) { nil }
  end
  let(:override_config) { nil }
  let(:merge_configs) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: resource, platform: platform, version: platform_version
    ) do |node|
      %i(resource name config properties action).each do |p|
        node.set['dnsmasq_local_resource_test'][p] = send(p) unless send(p).nil?
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

        shared_examples_for 'any attributes' do
          it 'creates the dnsmasq.d directory' do
            expect(chef_run).to create_directory('/etc/dnsmasq.d')
          end
        end

        context 'the default attributes' do
          let(:config) { nil }
          let(:properties) { nil }
          cached(:chef_run) { converge }

          it_behaves_like 'any attributes'

          it 'generates the expected config' do
            expected = <<-EOH.gsub(/^ {14}/, '').strip
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
          let(:config) do
            {
              interface: 'docker0',
              no_hosts: false,
              example: 'elpmaxe',
              bool: true,
              other_bool: false
            }
          end
          let(:properties) { nil }
          cached(:chef_run) { converge }

          it_behaves_like 'any attributes'

          it 'generates the expected config' do
            expected = <<-EOH.gsub(/^ {14}/, '').strip
              bool
              example=elpmaxe
              interface=docker0
            EOH
            expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
              .with(content: expected)
          end
        end

        context 'some extra configs to merge in with the default' do
          let(:config) { nil }
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
            expected = <<-EOH.gsub(/^ {14}/, '').strip
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
          let(:config) { { example: :bad } }
          let(:properties) { nil }
          cached(:chef_run) { converge }

          it 'raises an error' do
            expected = Chef::Exceptions::ValidationFailed
            expect { chef_run }.to raise_error(expected)
          end
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

        it 'deletes the dnsmasq.d directory' do
          expect(chef_run).to delete_directory('/etc/dnsmasq.d')
            .with(recursive: true)
        end
      end
    end
  end
end
