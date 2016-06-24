require_relative '../../../spec_helper'
require_relative '../../dnsmasq_local_service'

describe 'dnsmasq_local_service::centos::6_8' do
  include_context 'dnsmasq_local_service'

  let(:platform) { 'centos' }
  let(:platform_version) { '6.8' }

  context 'the default action ([:create, :enable, :start])' do
    include_context 'the default action ([:create, :enable, :start])'

    it 'raises an error' do
      expect { chef_run }.to raise_error(NoMethodError)
    end
  end

  %i(enable disable start stop).each do |a|
    context "the :#{a} action" do
      include_context "the :#{a} action"

      it_behaves_like 'any platform'
    end
  end

  context 'the :remove action' do
    include_context 'the :remove action'

    it 'raises an error' do
      expect { chef_run }.to raise_error(NoMethodError)
    end
  end
end
