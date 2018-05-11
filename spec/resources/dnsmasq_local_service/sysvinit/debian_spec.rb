# frozen_string_literal: true

require_relative '../sysvinit'

describe 'resources::dnsmasq_local_service::sysvinit::debian' do
  include_context 'resources::dnsmasq_local_service::sysvinit'

  shared_examples_for 'any Sysvinit Debian platform' do
    it_behaves_like 'any Sysvinit platform'
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[ubuntu debian].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any Sysvinit Debian platform'
        end
      end
    end
  end
end
