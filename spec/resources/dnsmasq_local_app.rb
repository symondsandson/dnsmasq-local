# frozen_string_literal: true

require_relative '../resources'

shared_context 'resources::dnsmasq_local_app' do
  include_context 'resources'

  let(:resource) { 'dnsmasq_local_app' }
  %i[version].each { |p| let(p) { nil } }
  let(:properties) { { version: version } }
  let(:name) { 'default' }

  shared_context 'the :install action' do
  end

  shared_context 'the :upgrade action' do
    let(:action) { :upgrade }
  end

  shared_context 'the :remove action' do
    let(:action) { :remove }
  end

  shared_context 'all default properties' do
  end

  shared_context 'an overridden version property' do
    let(:version) { '1.2.3' }
  end

  shared_examples_for 'any platform' do
    context 'the :install action' do
      include_context description

      context 'all default properties' do
        include_context description

        it 'installs the Dnsmasq package' do
          expect(chef_run).to install_package('dnsmasq')
        end
      end

      context 'an overridden version property' do
        include_context description

        it 'installs the requested version of the Dnsmasq package' do
          expect(chef_run).to install_package('dnsmasq').with(version: '1.2.3')
        end
      end
    end

    context 'the :upgrade action' do
      include_context description

      it 'upgrades the Dnsmasq package' do
        expect(chef_run).to upgrade_package('dnsmasq')
      end
    end
  end
end
