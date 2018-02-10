# frozen_string_literal: true

describe package('dnsmasq') do
  it { should_not be_installed }
end
