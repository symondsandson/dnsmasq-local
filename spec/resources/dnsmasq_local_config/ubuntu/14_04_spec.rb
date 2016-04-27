require_relative '../../../spec_helper'

describe 'resource_dnsmasq_local_config::ubuntu::14_04' do
  let(:override_config) { nil }
  let(:merge_configs) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'dnsmasq_local_config', platform: 'ubuntu', version: '14.04'
    ) do |node|
      unless override_config.nil?
        node.set['dnsmasq_local']['override_config'] = override_config
      end
      unless merge_configs.nil?
        node.set['dnsmasq_local']['merge_configs'] = merge_configs
      end
    end
  end
  let(:converge) do
    runner.converge("resource_dnsmasq_local_config_test::#{action}")
  end

  context 'the default action (:create)' do
    let(:action) { :default }

    shared_examples_for 'any attributes' do
      it 'creates the dnsmasq.d directory' do
        expect(chef_run).to create_directory('/etc/dnsmasq.d')
      end
    end

    context 'the default attributes' do
      let(:override_config) { nil }
      let(:merge_configs) { nil }
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
      let(:override_config) do
        {
          interface: 'docker0',
          no_hosts: false,
          example: 'elpmaxe',
          bool: true,
          other_bool: false
        }
      end
      let(:merge_configs) { nil }
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
      let(:override_config) { nil }
      let(:merge_configs) do
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
      let(:override_config) { { example: :bad } }
      let(:merge_configs) { nil }
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
