# frozen_string_literal: true

describe file('/etc/default/dnsmasq') do
  its(:content) do
    expected = <<-EXP.gsub(/^ +/, '').strip
      # This file is managed by Chef.
      # Any changes to it will be overwritten.
      DNSMASQ_OPTS='--all-servers'
      FAKE='certainly'
    EXP
    should eq(expected)
  end
end

describe service('dnsmasq') do
  it { should be_enabled }
  it { should be_running }
end

resolvconf = if os.debian?
               '/run/resolvconf/resolv.conf'
             elsif os.redhat?
               '/var/run/dnsmasq/resolv.conf.new'
             end

describe file(resolvconf) do
  its(:content) { should match(/^nameserver 127\.0\.0\.1$/) }
end
