# encoding: utf-8
# frozen_string_literal: true
require_relative '../resources'

shared_context 'resources::dnsmasq_local_app' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_app' }
  %i(version).each { |p| let(p) { nil } }
  let(:properties) { { version: version } }
  let(:name) { 'default' }

  shared_examples_for 'any platform' do
    context 'the default action (:install)' do
      context 'the default attributes' do
        it 'installs the Dnsmasq package' do
          expect(chef_run).to install_package('dnsmasq')
        end
      end

      context 'an overridden version attribute' do
        let(:version) { '1.2.3' }

        it 'installs the requested version of the Dnsmasq package' do
          expect(chef_run).to install_package('dnsmasq').with(version: '1.2.3')
        end
      end
    end

    context 'the :upgrade action' do
      let(:action) { :upgrade }

      it 'upgrades the Dnsmasq package' do
        expect(chef_run).to upgrade_package('dnsmasq')
      end
    end
  end

  shared_context 'the default action (:install)' do
  end

  shared_context 'the :upgrade action' do
    let(:action) { :upgrade }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end
end
