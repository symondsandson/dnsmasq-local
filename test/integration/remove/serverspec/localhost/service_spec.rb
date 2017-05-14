# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::remove::service' do
  describe file('/etc/default/dnsmasq') do
    it 'does not exist' do
      expect(subject).to_not exist
    end
  end

  describe service('dnsmasq') do
    it 'is not enabled' do
      expect(subject).to_not be_enabled
    end

    it 'is not running' do
      expect(subject).to_not be_running
    end
  end

  describe file('/run/resolvconf/resolv.conf'),
           if: %w[ubuntu debian].include?(os[:family]) do
    it 'is not using localhost as the nameserver' do
      expect(subject.content).to_not match(/^nameserver 127\.0\.0\.1$/)
    end
  end

  describe file('/var/run/dnsmasq/resolv.conf.new'),
           if: os[:family] == 'redhat' do
    it 'is not using localhost as the nameserver' do
      expect(subject.content).to_not match(/^nameserver 127\.0\.0\.1$/)
    end
  end
end
