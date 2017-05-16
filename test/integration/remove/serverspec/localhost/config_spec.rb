# encoding: utf-8
# frozen_string_literal: true

require_relative '../spec_helper'

describe 'dnsmasq-local::remove::config' do
  %w[
    /etc/dnsmasq.conf
    /etc/dnsmasq.d/default.conf
    /etc/dnsmasq.d
  ].each do |f|
    describe file(f) do
      it 'does not exist' do
        expect(subject).to_not exist
      end
    end
  end
end
