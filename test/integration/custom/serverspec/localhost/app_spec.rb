# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::custom::app' do
  describe package('dnsmasq') do
    it 'is installed' do
      expect(subject).to be_installed
    end
  end
end
