# Encoding: UTF-8

require_relative '../spec_helper'

describe 'dnsmasq-local::default' do
  let(:platform) { { platform: 'ubuntu', version: '14.04' } }
  let(:runner) { ChefSpec::SoloRunner.new(platform) }
  let(:chef_run) { runner.converge(described_recipe) }

  it 'creates the dnsmasq.d directory' do
    expect(chef_run).to create_directory('/etc/dnsmasq.d')
  end

  it 'creates the dns.conf file' do
    expected = <<-EOH.gsub(/^ {6}/, '').strip
      interface=
      cache-size=0
      no-hosts
      bind-interfaces
      proxy-dnssec
      query-port=0
    EOH
    expect(chef_run).to create_file('/etc/dnsmasq.d/dns.conf')
      .with_content(expected)
    expect(chef_run.file('/etc/dnsmasq.d/dns.conf'))
      .to notify('service[dnsmasq]').to(:restart)
  end

  it 'installs dnsmasq' do
    expect(chef_run).to install_package('dnsmasq')
  end

  it 'enables the dnsmasq service' do
    expect(chef_run).to enable_service('dnsmasq')
  end

  it 'starts the dnsmasq service' do
    expect(chef_run).to start_service('dnsmasq')
  end
end
