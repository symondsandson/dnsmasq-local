# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::dnsmasq_local_app::rhel::6' do
  include_context 'resources::dnsmasq_local_app::rhel'

  shared_examples_for 'any RHEL 6 platform' do
    it_behaves_like 'any RHEL platform'

    context 'the :remove action' do
      include_context description

      it 'removes the dnsmasq package via rpm' do
        expect(chef_run).to remove_rpm_package('dnsmasq')
          .with(options: %w[--noscripts])
      end
    end
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[redhat centos].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        next unless ver.to_i <= 6

        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any RHEL 6 platform'
        end
      end
    end
  end
end
