require_relative '../spec_helper'

describe 'dnsmasq_local_service' do
  let(:resource) { 'dnsmasq_local_service' }
  let(:name) { 'default' }
  %i(platform platform_version environment properties action).each do |p|
    let(p) { nil }
  end
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: resource, platform: platform, version: platform_version
    ) do |node|
      %i(resource name environment properties action).each do |p|
        unless send(p).nil?
          node.default['dnsmasq_local_resource_test'][p] = send(p)
        end
      end
    end
  end
  let(:converge) { runner.converge('dnsmasq_local_resource_test') }

  context 'the default action ([:create, :enable, :start])' do
    let(:action) { nil }

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }

      context '16.04' do
        let(:platform_version) { '16.04' }
        cached(:chef_run) { converge }

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ {12}/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
            ENABLED='1'
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
  end

  context 'the :create action' do
    let(:action) { :create }

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }

      context '16.04' do
        let(:platform_version) { '16.04' }

        context 'the default attributes' do
          let(:environment) { nil }
          let(:properties) { nil }
          cached(:chef_run) { converge }

          it 'creates the defaults file' do
            expected = <<-EOH.gsub(/^ {14}/, '').strip
              # This file is managed by Chef.
              # Any changes to it will be overwritten.
              CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
              ENABLED='1'
            EOH
            expect(chef_run).to create_file('/etc/default/dnsmasq')
              .with(content: expected)
          end
        end

        context 'a default environment override' do
          let(:environment) { { enabled: 0, testing: 'yes' } }
          let(:properties) { nil }
          cached(:chef_run) { converge }

          it 'generates the expected defaults file' do
            expected = <<-EOH.gsub(/^ {14}/, '').strip
              # This file is managed by Chef.
              # Any changes to it will be overwritten.
              ENABLED='0'
              TESTING='yes'
            EOH
            expect(chef_run).to create_file('/etc/default/dnsmasq')
              .with(content: expected)
          end
        end

        context 'some extra environment vars to merge in with the default' do
          let(:environment) { nil }
          let(:properties) { { dnsmasq_opts: '--bind-dynamic' } }
          cached(:chef_run) { converge }

          it 'generates the expected defaults file' do
            expected = <<-EOH.gsub(/^ {14}/, '').strip
              # This file is managed by Chef.
              # Any changes to it will be overwritten.
              CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
              DNSMASQ_OPTS='--bind-dynamic'
              ENABLED='1'
            EOH
            expect(chef_run).to create_file('/etc/default/dnsmasq')
              .with(content: expected)
          end
        end
      end
    end
  end

  %i(enable disable start stop).each do |a|
    context "the #{a} action" do
      let(:action) { a }

      context 'Ubuntu' do
        let(:platform) { 'ubuntu' }

        context '16.04' do
          let(:platform_version) { '16.04' }
          let(:chef_run) { converge }

          it 'passes the action on to a service resource' do
            expect(chef_run).to send("#{a}_service", "#{a} dnsmasq").with(
              service_name: 'dnsmasq', supports: { restart: true, status: true }
            )
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

        it 'deletes the defaults file' do
          expect(chef_run).to delete_file('/etc/default/dnsmasq')
        end
      end
    end
  end
end
