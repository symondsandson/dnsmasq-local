# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::custom::config' do
  describe file('/etc/dnsmasq.conf') do
    it 'is pointed at the .d config dir' do
      expect(subject.content).to match(%r{^conf-dir=/etc/dnsmasq\.d$})
    end
  end

  describe file('/etc/dnsmasq.d/dns.conf') do
    it 'is listening on the local interface only' do
      expect(subject.content).to match(/^interface=$/)
    end

    it 'does not have bind-interfaces set' do
      expect(subject.content).to_not match(/^bind-interfaces$/)
    end

    it 'is caching lookup results' do
      expect(subject.content).to match(/^cache-size=64$/)
    end

    it 'is sticking to the system ephemeral port range' do
      expect(subject.content).to match(/^query-port=0$/)
    end

    it 'is pointed at Google nameservers' do
      expect(subject.content).to match(/^server=8\.8\.8\.8$/)
      expect(subject.content).to match(/^server=8\.8\.4\.4$/)
    end

    it 'has a custom DNS entry for example.biz' do
      expect(subject.content).to match(%r{^address=/example.biz/127\.0\.0\.1$})
    end
  end
end
