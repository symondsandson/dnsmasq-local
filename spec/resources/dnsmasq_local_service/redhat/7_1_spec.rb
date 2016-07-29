# encoding: utf-8
# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::dnsmasq_local_service::redhat::7_1' do
  include_context 'resources::dnsmasq_local_service::rhel'

  let(:platform) { 'redhat' }
  let(:platform_version) { '7.1' }

  it_behaves_like 'any RHEL platform'

  shared_examples_for 'systemd patching' do
    before(:each) do
      allow(File).to receive(:read).and_call_original
      orig = <<-EOH.gsub(/^ +/, '')
        [Unit]
        Description=DNS caching server.
        After=network.target

        [Service]
        ExecStart=/usr/sbin/dnsmasq -k

        [Install]
        WantedBy=multi-user.target
      EOH
      allow(File).to receive(:read)
        .with('/usr/lib/systemd/system/dnsmasq.service').and_return(orig)
    end

    it 'patches the dnsmasq Systemd file' do
      expected = <<-EOH.gsub(/^ +/, '')
        [Unit]
        Description=DNS caching server.
        After=network.target

        [Service]
        EnvironmentFile=/etc/default/dnsmasq
        ExecStart=/usr/sbin/dnsmasq -k $DNSMASQ_OPTS

        [Install]
        WantedBy=multi-user.target
      EOH
      expect(chef_run).to create_file('/usr/lib/systemd/system/dnsmasq.service')
        .with(content: expected)
    end

    it 'runs a daemon-reload' do
      expect(chef_run.execute('systemctl daemon-reload')).to do_nothing
      expect(chef_run.file('/usr/lib/systemd/system/dnsmasq.service'))
        .to notify('execute[systemctl daemon-reload]').to(:run).immediately
    end
  end

  context 'the default action ([:create, :enable, :start])' do
    include_context description

    it_behaves_like 'systemd patching'
  end

  context 'the :create action' do
    include_context description

    it_behaves_like 'systemd patching'
  end

  context 'the :remove action' do
    include_context description

    it 'deletes the Dnsmasq Systemd file' do
      expect(chef_run).to delete_file('/usr/lib/systemd/system/dnsmasq.service')
    end
  end
end
