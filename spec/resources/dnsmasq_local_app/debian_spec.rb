# frozen_string_literal: true

require_relative '../dnsmasq_local_app'

describe 'resources::dnsmasq_local_app::debian' do
  include_context 'resources::dnsmasq_local_app'

  shared_examples_for 'any Debian platform' do
    it_behaves_like 'any platform'

    %i[install upgrade].each do |act|
      context "the :#{act} action" do
        include_context description

        it 'tells APT To leave the config files in place' do
          expect(chef_run).to send("#{act}_package", 'dnsmasq')
            .with(options: %w[-o Dpkg::Options::=--force-confold])
        end
      end
    end

    context 'the :remove action' do
      include_context description

      it 'purges the dnsmasq packages' do
        %w[dnsmasq dnsmasq-base].each do |p|
          expect(chef_run).to purge_package(p)
        end
      end
    end
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[ubuntu debian].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any Debian platform'
        end
      end
    end
  end
end
