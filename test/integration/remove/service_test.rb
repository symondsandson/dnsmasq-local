# frozen_string_literal: true

describe file('/etc/default/dnsmasq') do
  it { should_not exist }
end

describe service('dnsmasq') do
  it { should_not be_enabled }
  it { should_not be_running }
end

resolvconf = if os.debian?
               '/run/resolvconf/resolv.conf'
             elsif os.redhat?
               '/var/run/dnsmasq/resolv.conf.new'
             end

describe file(resolvconf) do
  its(:content) { should_not match(/^nameserver 127\.0\.0\.1$/) }
end
