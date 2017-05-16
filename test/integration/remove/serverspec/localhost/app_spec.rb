# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::remove::app' do
  describe package('dnsmasq') do
    it 'is not installed' do
      expect(subject).to_not be_installed
    end
  end
end
