# encoding: utf-8
# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::dnsmasq_local_service' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_service' }
  %i[options environment network_manager_enabled].each { |p| let(p) { nil } }
  let(:properties) { { options: options, environment: environment } }
  let(:name) { 'default' }

  let(:network_manager_running?) { nil }

  before(:each) do
    allow_any_instance_of(Chef::Mixin::ShellOut).to receive(:shell_out)
      .with('pgrep NetworkManager')
      .and_return(double(exitstatus: network_manager_running? ? 0 : 1))
  end

  shared_context 'the default action' do
  end

  shared_context 'the :create action' do
    let(:action) { :create }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'the :enable action' do
    let(:action) { :enable }
  end

  shared_context 'the :disable action' do
    let(:action) { :disable }
  end

  shared_context 'the :start action' do
    let(:action) { :start }
  end

  shared_context 'the :stop action' do
    let(:action) { :stop }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden options property' do
    let(:options) { { thing_1: true, thing_2: 'test', bad: false } }
  end

  shared_context 'some extra properties' do
    let(:properties) { { thing_1: true, thing_2: 'test', bad: false } }
  end

  shared_context 'an overridden environment property' do
    let(:environment) { { PANTS: 'no', SHORTS: 'yes' } }
  end

  shared_context 'an invalid environment property' do
    let(:environment) { { PANTS: 'no', SHORTS: 'yes', DNSMASQ_OPTS: '--bad' } }
  end

  shared_context 'the NetworkManager service running' do
    let(:network_manager_running?) { true }
  end

  shared_examples_for 'any platform' do
    context 'the default action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end

        it 'enables the dnsmasq service' do
          expect(chef_run).to enable_service('enable dnsmasq').with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end

        it 'starts the dnsmasq service' do
          expect(chef_run).to start_service('start dnsmasq').with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end
      end
    end

    context 'the :create action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'creates the defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'an overridden options property' do
        include_context description

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS='--thing-1 --thing-2=test'
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'some extra properties' do
        include_context description

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS='--thing-1 --thing-2=test'
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'an overridden environment property' do
        include_context description

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
            PANTS='no'
            SHORTS='yes'
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end

      context 'an invalid environment property' do
        include_context description

        it 'raises an error' do
          expect { chef_run }.to raise_error(Chef::Exceptions::ValidationFailed)
        end
      end

      context 'the NetworkManager service running' do
        include_context description

        it 'defines a NetworkManager service resource' do
          expect(chef_run.service('NetworkManager')).to do_nothing
        end

        it 'drops off a Dnsmasq NetworkManager config' do
          f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
          expect(chef_run).to create_file(f).with(content: "[main]\ndns=none")
          expect(chef_run.file(f)).to notify('service[NetworkManager]')
            .to(:restart).immediately
        end

        it 'creates the defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            DNSMASQ_OPTS=''
          EOH
          expect(chef_run).to create_file('/etc/default/dnsmasq')
            .with(content: expected)
        end
      end
    end

    context 'the :remove action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'deletes the defaults file' do
          expect(chef_run).to delete_file('/etc/default/dnsmasq')
        end
      end

      context 'the NetworkManager service running' do
        include_context description

        it 'defines a NetworkManager service resource' do
          expect(chef_run.service('NetworkManager')).to do_nothing
        end

        it 'deletes the Dnsmasq NetworkManager config' do
          f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
          expect(chef_run).to delete_file(f)
          expect(chef_run.file(f)).to notify('service[NetworkManager]')
            .to(:restart).immediately
        end
      end
    end

    %i[enable disable start stop].each do |a|
      context "the :#{a} action" do
        include_context description

        it 'passes the action on to a service resource' do
          expect(chef_run).to send("#{a}_service", "#{a} dnsmasq").with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end
      end
    end
  end
end
