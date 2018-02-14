# frozen_string_literal: true

describe package('dnsmasq') do
  it { should be_installed }
end
