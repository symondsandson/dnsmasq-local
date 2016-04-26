# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::default::service' do
  describe service('dnsmasq') do
    it 'is enabled' do
      expect(subject).to be_enabled
    end

    it 'is running' do
      expect(subject).to be_running
    end
  end

  describe command('host -t a google.com') do
    it 'indicates DNS lookups are succeeding' do
      expect(subject.exit_status).to eq(0)
      expected = /^google\.com has address [0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/
      expect(subject.stdout).to match(expected)
    end
  end
end
