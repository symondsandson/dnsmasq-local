# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::default::config' do
  describe file('/etc/dnsmasq.conf') do
    it 'is pointed at the .d config dir' do
      expect(subject.content).to match(%r{^conf-dir=/etc/dnsmasq\.d$})
    end
  end

  describe file('/etc/dnsmasq.d/dns.conf') do
    it 'is listening on the local interface only' do
      expect(subject.content).to match(/^interface=$/)
    end

    it 'has bind-interfaces set' do
      expect(subject.content).to match(/^bind-interfaces$/)
    end

    it 'is not caching lookup results' do
      expect(subject.content).to match(/^cache-size=0$/)
    end

    it 'is sticking to the system ephemeral port range' do
      expect(subject.content).to match(/^query-port=0$/)
    end
  end
end
