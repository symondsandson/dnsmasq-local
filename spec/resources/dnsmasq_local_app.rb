require_relative '../spec_helper'
require_relative '../resources'

shared_context 'dnsmasq_local_app' do
  include_context 'any custom resource'

  let(:resource) { 'dnsmasq_local_app' }
  let(:properties) { {} }
  let(:name) { 'default' }

  shared_context 'the default action (:install)' do
    cached(:chef_run) { converge }

    shared_examples_for 'any platform' do
      it 'installs the Dnsmasq package' do
        expect(chef_run).to install_package('dnsmasq')
      end
    end
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
    cached(:chef_run) { converge }

    shared_examples_for 'any Debian platform' do
      it 'purges the dnsmasq packages' do
        %w(dnsmasq dnsmasq-base).each do |p|
          expect(chef_run).to purge_package(p)
        end
      end
    end
  end
end
