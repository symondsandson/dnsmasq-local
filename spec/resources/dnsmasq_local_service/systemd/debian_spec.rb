# frozen_string_literal: true

require_relative '../systemd'

describe 'resources::dnsmasq_local_service::systemd::debian' do
  include_context 'resources::dnsmasq_local_service::systemd'

  shared_examples_for 'any Systemd Debian platform' do
    it_behaves_like 'any Systemd platform'
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[ubuntu debian].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any Systemd Debian platform'
        end
      end
    end
  end
end
