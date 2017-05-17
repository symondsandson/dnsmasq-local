# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::default' do
  %i[config options environment].each { |a| let(a) { nil } }
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) do
    ChefSpec::SoloRunner.new(platform) do |node|
      %i[config options environment].each do |a|
        node.normal['dnsmasq_local'][a] = send(a) unless send(a).nil?
      end
    end
  end
  let(:chef_run) { runner.converge(described_recipe) }

  shared_examples_for 'any attribute set' do
    it 'creates a dnsmasq_local resource' do
      expect(chef_run).to create_dnsmasq_local('default')
        .with(config: config || {},
              options: options || {},
              environment: environment || {})
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

  context 'an overridden options attribute' do
    let(:options) { { 'bind_dynamic' => true } }

    it_behaves_like 'any attribute set'
  end

  context 'an overridden environment attribute' do
    let(:environment) { { 'IGNORE_RESOLVCONF' => 'yes', 'PANTS' => 'no' } }

    it_behaves_like 'any attribute set'
  end
end
