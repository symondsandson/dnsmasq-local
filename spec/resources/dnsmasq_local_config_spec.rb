# frozen_string_literal: true

require_relative '../resources'

describe 'resources::dnsmasq_local_config' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_config' }
  %i[filename config].each { |p| let(p) { nil } }
  let(:properties) { { filename: filename, config: config } }
  let(:name) { 'default' }

  shared_context 'the :create action' do
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden filename property' do
    let(:filename) { 'monkeypants.conf' }
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
        server: %w[8.8.8.8 8.8.4.4],
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
          expected = <<-EXP.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            conf-dir=/etc/dnsmasq.d
          EXP
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
          expected = <<-EXP.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            cache-size=0
            interface=
            no-hosts
            query-port=0
          EXP
          expect(chef_run).to create_file('/etc/dnsmasq.d/default.conf')
            .with(content: expected)
        end
      end

      context 'an overridden filename property' do
        include_context description

        it 'generates the expected config' do
          expected = <<-EXP.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bind-interfaces
            cache-size=0
            interface=
            no-hosts
            query-port=0
          EXP
          expect(chef_run).to create_file('/etc/dnsmasq.d/monkeypants.conf')
            .with(content: expected)
        end
      end

      context 'an overridden config property' do
        include_context description

        it_behaves_like 'any property set'

        it 'generates the expected config' do
          expected = <<-EXP.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            bool
            example=elpmaxe
            interface=docker0
          EXP
          expect(chef_run).to create_file('/etc/dnsmasq.d/default.conf')
            .with(content: expected)
        end
      end

      context 'some extra properties' do
        include_context description

        it_behaves_like 'any property set'

        it 'generates the expected config' do
          expected = <<-EXP.gsub(/^ +/, '').strip
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
          EXP
          expect(chef_run).to create_file('/etc/dnsmasq.d/default.conf')
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

    context 'the :remove action' do
      include_context description

      let(:other_conf_files?) { nil }

      before do
        allow(Dir).to receive(:exist?).and_call_original
        allow(Dir).to receive(:exist?).with('/etc/dnsmasq.d').and_return(true)
        allow(Dir).to receive(:entries).and_call_original
        allow(Dir).to receive(:entries)
          .with('/etc/dnsmasq.d')
          .and_return(other_conf_files? ? %w[. .. thing2.conf] : %w[. ..])
      end

      shared_examples_for 'any property set' do
        it 'deletes the config file' do
          expect(chef_run).to delete_file(
            "/etc/dnsmasq.d/#{filename || 'default.conf'}"
          )
        end
      end

      shared_examples_for 'an empty conf.d dir' do
        it 'deletes the conf.d dir' do
          expect(chef_run).to delete_directory('/etc/dnsmasq.d')
        end

        it 'deletes the main config file' do
          expect(chef_run).to delete_file('/etc/dnsmasq.conf')
        end
      end

      shared_examples_for 'a populated conf.d dir' do
        it 'does not delete the conf.d dir' do
          expect(chef_run).to_not delete_directory('/etc/dnsmasq.d')
        end

        it 'does not delete the main config file' do
          expect(chef_run).to_not delete_file('/etc/dnsmasq.conf')
        end
      end

      context 'all default properties' do
        include_context description

        context 'an empty conf.d dir' do
          let(:other_conf_files?) { false }

          it_behaves_like 'any property set'
          it_behaves_like 'an empty conf.d dir'
        end

        context 'a populated conf.d dir' do
          let(:other_conf_files?) { true }

          it_behaves_like 'any property set'
          it_behaves_like 'a populated conf.d dir'
        end
      end

      context 'an overridden filename property' do
        include_context description

        context 'an empty conf.d dir' do
          let(:other_conf_files?) { false }

          it_behaves_like 'any property set'
          it_behaves_like 'an empty conf.d dir'
        end

        context 'a populated conf.d dir' do
          let(:other_conf_files?) { true }

          it_behaves_like 'any property set'
          it_behaves_like 'a populated conf.d dir'
        end
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
