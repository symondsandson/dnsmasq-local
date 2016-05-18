require_relative '../../../spec_helper'

describe 'resource_dnsmasq_local_config::ubuntu::14_04' do
  let(:name) { 'default' }
  %i(config properties action).each { |p| let(p) { nil } }
  let(:override_config) { nil }
  let(:merge_configs) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'dnsmasq_local_config', platform: 'ubuntu', version: '14.04'
    ) do |node|
      %i(name config properties action).each do |p|
        unless send(p).nil?
          node.set['resource_dnsmasq_local_config_test'][p] = send(p)
        end
      end
    end
  end
  let(:converge) { runner.converge('resource_dnsmasq_local_config_test') }

  context 'the default action (:create)' do
    let(:action) { nil }

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
        expected = <<-EOH.gsub(/^ {10}/, '').strip
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
        expected = <<-EOH.gsub(/^ {10}/, '').strip
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
          bool: true,
          other_bool: false
        }
      end
      cached(:chef_run) { converge }

      it_behaves_like 'any attributes'

      it 'generates the expected config' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          bind-interfaces
          bool
          cache-size=0
          example=elpmaxe
          interface=docker0
          proxy-dnssec
          query-port=0
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
        expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'deletes the dnsmasq.d directory' do
      expect(chef_run).to delete_directory('/etc/dnsmasq.d')
        .with(recursive: true)
    end
  end
end
