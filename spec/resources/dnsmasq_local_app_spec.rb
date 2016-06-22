require_relative '../spec_helper'

describe 'dnsmasq_local_app' do
  let(:resource) { 'dnsmasq_local_app' }
  let(:name) { 'default' }
  %i(platform platform_version action).each { |p| let(p) { nil } }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: resource, platform: platform, version: platform_version
    ) do |node|
      %i(resource name action).each do |p|
        node.set['dnsmasq_local_resource_test'][p] = send(p) unless send(p).nil?
      end
    end
  end
  let(:converge) do
    runner.converge('dnsmasq_local_resource_test')
  end

  context 'the default action (:install)' do
    let(:action) { nil }

    context 'Ubuntu' do
      let(:platform) { 'ubuntu' }

      context '16.04' do
        let(:platform_version) { '16.04' }
        cached(:chef_run) { converge }

        it 'installs the Dnsmasq package' do
          expect(chef_run).to install_package('dnsmasq')
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

        it 'purges the dnsmasq packages' do
          %w(dnsmasq dnsmasq-base).each do |p|
            expect(chef_run).to purge_package(p)
          end
        end
      end
    end
  end
end
