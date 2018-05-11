# frozen_string_literal: true

require_relative '../systemd'

describe 'resources::dnsmasq_local_service::systemd::rhel' do
  include_context 'resources::dnsmasq_local_service::systemd'

  shared_examples_for 'any Systemd RHEL platform' do
    it_behaves_like 'any Systemd platform'

    context 'the :create action' do
      include_context description

      it 'creates the Dnsmasq service directory' do
        d = '/etc/systemd/system/dnsmasq.service.d'
        expect(chef_run).to create_directory(d)
      end

      it 'creates the Dnsmasq service override file' do
        expected = <<-EXP.gsub(/^ +/, '').strip
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
        EXP
        f = '/etc/systemd/system/dnsmasq.service.d/local.conf'
        expect(chef_run).to create_file(f).with(content: expected)
      end

      it 'runs a daemon-reload' do
        expect(chef_run.execute('systemctl daemon-reload')).to do_nothing
        f = chef_run.file('/etc/systemd/system/dnsmasq.service.d/local.conf')
        expect(f).to notify('execute[systemctl daemon-reload]').to(:run)
                                                               .immediately
      end
    end

    context 'the :remove action' do
      include_context description

      it 'deletes the Dnsmasq service override file' do
        expect(chef_run).to delete_file('/etc/systemd/system/' \
                                        'dnsmasq.service.d/local.conf')
      end

      it 'deletes the Dnsmasq service directory' do
        expect(chef_run).to delete_directory('/etc/systemd/system/' \
                                             'dnsmasq.service.d')
      end
    end
  end

  RSpec.configuration.supported_platforms.each do |os, versions|
    next unless %w[redhat centos].include?(os.to_s)

    context os.to_s.capitalize do
      let(:platform) { os.to_s }

      versions.each do |ver|
        next unless ver.to_i >= 7

        context ver do
          let(:platform_version) { ver }

          it_behaves_like 'any Systemd RHEL platform'
        end
      end
    end
  end
end
