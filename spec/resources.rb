require_relative 'spec_helper'

shared_context 'any custom resource' do
  %i(resource name platform platform_version action).each { |p| let(p) { nil } }
  let(:properties) { {} }
  let(:runner) do
    ChefSpec::SoloRunner.new(
      step_into: resource, platform: platform, version: platform_version
    ) do |node|
      %i(resource name action).each do |p|
        next if send(p).nil?
        node.set['dnsmasq_local_resource_test'][p] = send(p)
      end
      properties.each do |k, v|
        next if v.nil?
        node.set['dnsmasq_local_resource_test']['properties'][k] = v
      end
    end
  end
  let(:converge) { runner.converge('dnsmasq_local_resource_test') }
end
