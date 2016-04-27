# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::default' do
  let(:config) { nil }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      node.set['dnsmasq_local']['config'] = config unless config.nil?
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any attribute set' do
    it 'creates a dnsmasq_local resource' do
      expect(chef_run).to create_dnsmasq_local('default')
        .with(config: config || {})
    end
  end

  context 'default attributes' do
    let(:config) { nil }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden config attribute' do
    let(:config) { { 'cache-size' => 10, 'no-hosts' => false } }

    it_behaves_like 'any attribute set'
  end
end
