# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::default::app' do
  describe package('dnsmasq') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
