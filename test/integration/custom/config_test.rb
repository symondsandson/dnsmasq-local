# frozen_string_literal: true

describe file('/etc/dnsmasq.conf') do
  its(:content) { should match(%r{^conf-dir=/etc/dnsmasq\.d$}) }
end

describe file('/etc/dnsmasq.d/default.conf') do
  [
    /^interface=$/,
    /^cache-size=64$/,
    /^query-port=0$/,
    /^server=8\.8\.8\.8$/,
    /^server=8\.8\.4\.4$/,
    %r{^address=/example.biz/127\.0\.0\.1$}
  ].each do |regex|
    its(:content) { should match(regex) }
  end
  its(:content) { should_not match(/^bind-interfaces$/) }
end
