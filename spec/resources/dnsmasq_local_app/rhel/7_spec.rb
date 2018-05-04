# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::dnsmasq_local_app::rhel::7' do
  include_context 'resources::dnsmasq_local_app::rhel'

  shared_examples_for 'any RHEL 7 platform' do
    it_behaves_like 'any RHEL platform'

    context 'the :remove action' do
      include_context description

      it 'removes the dnsmasq package via yum' do
        expect(chef_run).to remove_package('dnsmasq')
          .with(options: nil)
      end
    end
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[redhat centos].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        next unless ver.to_i >= 7

        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any RHEL 7 platform'
        end
      end
    end
  end
end
