require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_service'

describe 'dnsmasq_local_service::ubuntu::14_04' do
  include_context 'dnsmasq_local_service'

  let(:platform) { 'ubuntu' }
  let(:platform_version) { '14.04' }

  context 'the default action ([:create, :enable, :start])' do
    include_context 'the default action ([:create, :enable, :start])'

    it_behaves_like 'any Debian platform'
  end

  context 'the :create action' do
    include_context 'the :create action'

    it_behaves_like 'any Debian platform'
  end

  %i(enable disable start stop).each do |a|
    context "the :#{a} action" do
      include_context "the :#{a} action"

      it_behaves_like 'any platform'
    end
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it_behaves_like 'any Debian platform'
  end
end
