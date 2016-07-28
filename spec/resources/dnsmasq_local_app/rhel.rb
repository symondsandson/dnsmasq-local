# encoding: utf-8
# frozen_string_literal: true
require_relative '../dnsmasq_local_app'

shared_context 'resources::dnsmasq_local_app::rhel' do
  include_context 'resources::dnsmasq_local_app'

  shared_examples_for 'any RHEL platform' do
    context 'the default action (:install)' do
      include_context description

      it_behaves_like 'any platform'
    end

    context 'the :remove action' do
      include_context description

      shared_examples_for 'any RHEL platform' do
        it 'removes the dnsmasq package' do
          expect(chef_run).to remove_package('dnsmasq')
        end
      end
    end
  end
end
