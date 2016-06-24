require_relative '../spec_helper'
require_relative '../resources'

shared_context 'dnsmasq_local_service' do
  include_context 'any custom resource'

  let(:resource) { 'dnsmasq_local_service' }
  let(:properties) { { environment: nil } }
  let(:name) { 'default' }

  shared_context 'the default action ([:create, :enable, :start])' do
    cached(:chef_run) { converge }

    shared_examples_for 'any Debian platform' do
      it 'generates the expected defaults file' do
        expected = <<-EOH.gsub(/^ +/, '').strip
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

  shared_context 'the :create action' do
    let(:action) { :create }

    shared_examples_for 'any Debian platform' do
      context 'the default attributes' do
        cached(:chef_run) { converge }

        it 'creates the defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
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
        let(:properties) { { environment: { enabled: 0, testing: 'yes' } } }
        cached(:chef_run) { converge }

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
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
        let(:properties) { { dnsmasq_opts: '--bind-dynamic' } }
        cached(:chef_run) { converge }

        it 'generates the expected defaults file' do
          expected = <<-EOH.gsub(/^ +/, '').strip
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

  %i(enable disable start stop).each do |a|
    shared_context "the :#{a} action" do
      let(:action) { a }
      cached(:chef_run) { converge }

      shared_examples_for 'any platform' do
        it 'passes the action on to a service resource' do
          expect(chef_run).to send("#{a}_service", "#{a} dnsmasq").with(
            service_name: 'dnsmasq', supports: { restart: true, status: true }
          )
        end
      end
    end
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    shared_examples_for 'any Debian platform' do
      it 'deletes the defaults file' do
        expect(chef_run).to delete_file('/etc/default/dnsmasq')
      end
    end
  end
end
