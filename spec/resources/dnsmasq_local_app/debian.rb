# encoding: utf-8
# frozen_string_literal: true
require_relative '../dnsmasq_local_app'

shared_context 'resources::dnsmasq_local_app::debian' do
  include_context 'resources::dnsmasq_local_app'

  shared_examples_for 'any Debian platform' do
    context 'the default action (:install)' do
      include_context description

      it_behaves_like 'any platform'
    end
  
    context 'the :remove action' do
      include_context description

      it 'purges the dnsmasq packages' do
        %w(dnsmasq dnsmasq-base).each do |p|
          expect(chef_run).to purge_package(p)
        end
      end
    end
  end
end
