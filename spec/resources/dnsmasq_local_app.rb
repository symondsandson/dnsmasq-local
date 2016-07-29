# encoding: utf-8
# frozen_string_literal: true
require_relative '../resources'

shared_context 'resources::dnsmasq_local_app' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_app' }
  let(:properties) { {} }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:install)' do
      it 'installs the Dnsmasq package' do
        expect(chef_run).to install_package('dnsmasq')
      end
    end

    context 'the :upgrade action' do
      let(:action) { :upgrade }

      it 'upgrades the Dnsmasq package' do
        expect(chef_run).to upgrade_package('dnsmasq')
      end
    end
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end
end
