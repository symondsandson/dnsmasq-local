# encoding: utf-8
# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::dnsmasq_local_service::centos::7_0' do
  include_context 'resources::dnsmasq_local_service::rhel'

  let(:platform) { 'centos' }
  let(:platform_version) { '7.0' }

  it_behaves_like 'any RHEL platform'

  shared_examples_for 'systemd patching' do
    it 'defines a NetworkManager service resource' do
      expect(chef_run.service('NetworkManager')).to do_nothing
    end

    it 'drops off a Dnsmasq NetworkManager config' do
      f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
      expect(chef_run).to create_file(f).with(content: "[main]\ndns=none")
      expect(chef_run.file(f)).to notify('service[NetworkManager]')
        .to(:restart).immediately
    end

    it 'creates the Dnsmasq service directory' do
      d = '/etc/systemd/system/dnsmasq.service.d'
      expect(chef_run).to create_directory(d)
    end

    it 'creates the Dnsmasq service override file' do
      expected = <<-EOH.gsub(/^ +/, '').strip
        [Service]
        EnvironmentFile=/etc/default/dnsmasq

        ExecStartPre=/bin/mkdir -p /var/run/dnsmasq
        ExecStartPre=/bin/cp /etc/resolv.conf /var/run/dnsmasq/resolv.conf

        ExecStart=
        ExecStart=/usr/sbin/dnsmasq -k -r /var/run/dnsmasq/resolv.conf -x /var/run/dnsmasq/dnsmasq.pid $DNSMASQ_OPTS

        ExecStartPost=/bin/cp /var/run/dnsmasq/resolv.conf /var/run/dnsmasq/resolv.conf.new
        ExecStartPost=/bin/sed -i '/^nameserver/d' /var/run/dnsmasq/resolv.conf.new
        ExecStartPost=/bin/sh -c 'echo nameserver 127.0.0.1 >> /var/run/dnsmasq/resolv.conf.new'
        ExecStartPost=/bin/cp /var/run/dnsmasq/resolv.conf.new /etc/resolv.conf

        ExecStop=/bin/cp /var/run/dnsmasq/resolv.conf /etc/resolv.conf
        ExecStop=/bin/rm -rf /var/run/dnsmasq
      EOH
      f = '/etc/systemd/system/dnsmasq.service.d/local.conf'
      expect(chef_run).to create_file(f).with(content: expected)
    end

    it 'runs a daemon-reload' do
      expect(chef_run.execute('systemctl daemon-reload')).to do_nothing
      expect(chef_run.file('/etc/systemd/system/dnsmasq.service.d/local.conf'))
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

    it 'defines a NetworkManager service resource' do
      expect(chef_run.service('NetworkManager')).to do_nothing
    end

    it 'deletes the Dnsmasq NetworkManager config' do
      f = '/etc/NetworkManager/conf.d/20-dnsmasq.conf'
      expect(chef_run).to delete_file(f)
      expect(chef_run.file(f)).to notify('service[NetworkManager]')
        .to(:restart).immediately
    end

    it 'deletes the Dnsmasq service override file' do
      expect(chef_run).to delete_file('/etc/systemd/system/dnsmasq.service.d/' \
                                      'local.conf')
    end

    it 'deletes the Dnsmasq service directory' do
      expect(chef_run).to delete_directory('/etc/systemd/system/' \
                                           'dnsmasq.service.d')
    end
  end
end
