# frozen_string_literal: true

describe file('/etc/dnsmasq.conf') do
  it 'is pointed at the .d config dir' do
    expect(subject.content).to match(%r{^conf-dir=/etc/dnsmasq\.d$})
  end
end

describe file('/etc/dnsmasq.d/default.conf') do
  [
    /^interface=$/,
    /^bind-interfaces$/,
    /^cache-size=0$/,
    /^query-port=0$/
  ].each do |regex|
    its(:content) { should match(regex) }
  end
end
