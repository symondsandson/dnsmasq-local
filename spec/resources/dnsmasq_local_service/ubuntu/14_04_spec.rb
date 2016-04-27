require_relative '../../../spec_helper'

describe 'resource_dnsmasq_local_service::ubuntu::14_04' do
  let(:config) { nil }
  let(:runner) do
    ChefSpec::SoloRunner.new(step_into: 'dnsmasq_local_service',
                             platform: 'ubuntu',
                             version: '14.04')
  end
  let(:converge) do
    runner.converge("resource_dnsmasq_local_service_test::#{action}")
  end

  context 'the default action ([:enable, :start])' do
    let(:action) { :default }
    cached(:chef_run) { converge }

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
end
