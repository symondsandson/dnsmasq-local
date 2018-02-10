# frozen_string_literal: true

%w[
  /etc/dnsmasq.conf
  /etc/dnsmasq.d/default.conf
  /etc/dnsmasq.d
].each do |f|
  describe file(f) do
    it { should_not exist }
  end
end
