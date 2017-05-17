# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::custom::service' do
  describe file('/etc/default/dnsmasq') do
    it 'contains the expected environment variables' do
      expected = <<-EOH.gsub(/^ {8}/, '').strip
        # This file is managed by Chef.
        # Any changes to it will be overwritten.
        DNSMASQ_OPTS='--all-servers'
        FAKE='certainly'
      EOH
      expect(subject.content).to eq(expected)
    end
  end

  describe service('dnsmasq') do
    it 'is enabled' do
      expect(subject).to be_enabled
    end

    it 'is running' do
      expect(subject).to be_running
    end
  end

  describe file('/run/resolvconf/resolv.conf'),
           if: %w[ubuntu debian].include?(os[:family]) do
    it 'is using localhost as the nameserver' do
      expect(subject.content).to match(/^nameserver 127\.0\.0\.1$/)
    end
  end

  describe file('/var/run/dnsmasq/resolv.conf.new'),
           if: os[:family] == 'redhat' do
    it 'is using localhost as the nameserver' do
      expect(subject.content).to match(/^nameserver 127\.0\.0\.1$/)
    end
  end
end
