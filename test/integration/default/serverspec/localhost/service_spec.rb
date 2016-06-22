# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::default::service' do
  describe file('/etc/default/dnsmasq') do
    it 'contains the expected environment variables' do
      expected = <<-EOH.gsub(/^ +/, '').strip
        # This file is managed by Chef.
        # Any changes to it will be overwritten.
        CONFIG_DIR='/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
        ENABLED='1'
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

  describe file('/run/resolvconf/resolv.conf') do
    it 'is using localhost as the nameserver' do
      expect(subject.content).to match(/^nameserver 127\.0\.0\.1$/)
    end
  end
end
