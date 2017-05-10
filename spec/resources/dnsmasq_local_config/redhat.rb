# encoding: utf-8
# frozen_string_literal: true

require_relative 'rhel'

shared_context 'resources::dnsmasq_local_config::redhat' do
  include_context 'resources::dnsmasq_local_config::rhel'

  let(:platform) { 'redhat' }

  shared_examples_for 'any Red Hat platform' do
    it_behaves_like 'any RHEL platform'
  end
end
