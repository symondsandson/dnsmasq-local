require_relative '../../../spec_helper'

describe 'resource_dnsmasq_local_service::ubuntu::14_04' do
  let(:name) { 'default' }
  %i(environment properties action).each { |p| let(p) { nil } }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: 'dnsmasq_local_service', platform: 'ubuntu', version: '14.04'
    ) do |node|
      %i(name environment properties action).each do |p|
        unless send(p).nil?
          node.set['resource_dnsmasq_local_service_test'][p] = send(p)
        end
      end
    end
  end
  let(:converge) { runner.converge('resource_dnsmasq_local_service_test') }

  context 'the default action ([:create, :enable, :start])' do
    let(:action) { nil }
    cached(:chef_run) { converge }

    it 'generates the expected defaults file' do
      expect(chef_run).to create_file('/etc/default/dnsmasq').with(
        content: "CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'" \
                 "\nENABLED='1'"
      )
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

  context 'the :create action' do
    let(:action) { :create }

    context 'the default attributes' do
      let(:environment) { nil }
      let(:properties) { nil }
      cached(:chef_run) { converge }

      it 'creates the defaults file' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
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
        expect(chef_run).to create_file('/etc/default/dnsmasq').with(
          content: "ENABLED='0'\nTESTING='yes'"
        )
      end
    end

    context 'some extra environment vars to merge in with the default' do
      let(:environment) { nil }
      let(:properties) { { dnsmasq_opts: '--bind-dynamic' } }
      cached(:chef_run) { converge }

      it 'generates the expected defaults file' do
        expected = <<-EOH.gsub(/^ {10}/, '').strip
          CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
          DNSMASQ_OPTS='--bind-dynamic'
          ENABLED='1'
        EOH
        expect(chef_run).to create_file('/etc/default/dnsmasq')
          .with(content: expected)
      end
    end
  end

  %i(enable disable start stop).each do |a|
    context "the #{a} action" do
      let(:action) { a }
      cached(:chef_run) { converge }

      it 'passes the action on to a service resource' do
        expect(chef_run).to send("#{a}_service", "#{a} dnsmasq").with(
          service_name: 'dnsmasq', supports: { restart: true, status: true }
        )
      end
    end
  end

  context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    it 'deletes the defaults file' do
      expect(chef_run).to delete_file('/etc/default/dnsmasq')
    end
  end
end
