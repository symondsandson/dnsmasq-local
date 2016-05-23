# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::custom::config' do
  describe file('/etc/dnsmasq.d/dns.conf') do
    it 'is listening on the local interface only' do
      expect(subject.content).to match(/^interface=$/)
    end

    it 'is caching lookup results' do
      expect(subject.content).to match(/^cache-size=64$/)
    end

    it 'is sticking to the system ephemeral port range' do
      expect(subject.content).to match(/^query-port=0$/)
    end

    it 'is pointed at a Google nameserver' do
      expect(subject.content).to match(/^server=8\.8\.8\.8$/)
    end

    it 'has a custom DNS entry for example.biz' do
      expect(subject.content).to match(%r{^address=/example.biz/127\.0\.0\.1$})
    end
  end
end
