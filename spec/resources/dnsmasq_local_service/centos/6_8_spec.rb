# encoding: utf-8
# frozen_string_literal: true

require_relative '../rhel'

describe 'resources::dnsmasq_local_service::centos::6_8' do
  include_context 'resources::dnsmasq_local_service::rhel'

  let(:platform) { 'centos' }
  let(:platform_version) { '6.8' }

  it_behaves_like 'any RHEL platform'

  shared_examples_for 'init script patching' do
    before(:each) do
      allow(File).to receive(:read).and_call_original
      orig = <<-EOH.gsub(/^ {8}/, '')
        #!/bin/sh
        #
        # Startup script for the DNS caching server
        #
        # chkconfig: - 49 50
        # description: This script starts your DNS caching server
        # processname: dnsmasq
        # pidfile: /var/run/dnsmasq.pid

        # Source function library.
        . /etc/rc.d/init.d/functions

        # Source networking configuration.
        . /etc/sysconfig/network

        # Check that networking is up.
        [ ${NETWORKING} = "no" ] && exit 0

        dnsmasq=/usr/sbin/dnsmasq
        [ -f $dnsmasq ] || exit 0

        DOMAIN_SUFFIX=`dnsdomainname`
        if [ ! -z "${DOMAIN_SUFFIX}" ]; then
          OPTIONS="-s $DOMAIN_SUFFIX"
        fi

        RETVAL=0

        PIDFILE="/var/run/dnsmasq.pid"
      EOH
      allow(File).to receive(:read).with('/etc/init.d/dnsmasq')
        .and_return(orig)
    end

    it 'patches the dnsmasq init script to use env vars' do
      expected = <<-EOH.gsub(/^ {8}/, '')
        #!/bin/sh
        #
        # Startup script for the DNS caching server
        #
        # chkconfig: - 49 50
        # description: This script starts your DNS caching server
        # processname: dnsmasq
        # pidfile: /var/run/dnsmasq.pid

        # Source function library.
        . /etc/rc.d/init.d/functions

        # Source networking configuration.
        . /etc/sysconfig/network

        # Check that networking is up.
        [ ${NETWORKING} = "no" ] && exit 0

        dnsmasq=/usr/sbin/dnsmasq
        [ -f $dnsmasq ] || exit 0

        DOMAIN_SUFFIX=`dnsdomainname`
        if [ ! -z "${DOMAIN_SUFFIX}" ]; then
          OPTIONS="-s $DOMAIN_SUFFIX"
        fi

        . /etc/default/dnsmasq

        for INTERFACE in $DNSMASQ_INTERFACE; do
          DNSMASQ_INTERFACES="$DNSMASQ_INTERFACES -i $INTERFACE"
        done

        for INTERFACE in $DNSMASQ_EXCEPT; do
          DNSMASQ_INTERFACES="$DNSMASQ_INTERFACES -I $INTERFACE"
        done

        [ -n "$MAILHOSTNAME" ] && OPTIONS="$OPTIONS -m $MAILHOSTNAME"
        [ -n "$MAILTARGET" ] && OPTIONS="$OPTIONS -t $MAILTARGET"
        [ -n "$DNSMASQ_USER" ] && OPTIONS="$OPTIONS -u $DNSMASQ_USER"
        [ -n "$DNSMASQ_INTERFACES" ] && OPTIONS="$OPTIONS $DNSMASQ_INTERFACES"
        [ -n "$DHCP_LEASE" ] && OPTIONS="$OPTIONS -l $DHCP_LEASE"
        [ -n "$DOMAIN_SUFFIX" ] && OPTIONS="$OPTIONS -s $DOMAIN_SUFFIX"
        [ -n "$RESOLV_CONF" ] && OPTIONS="$OPTIONS -r $RESOLV_CONF"
        [ -n "$CACHESIZE" ] && OPTIONS="$OPTIONS -c $CACHESIZE"
        [ -n "$CONFIG_DIR" ] && OPTIONS="$OPTIONS -7 $CONFIG_DIR"
        [ -n "$DNSMASQ_OPTS" ] && OPTIONS="$OPTIONS $DNSMASQ_OPTS"

        RETVAL=0

        PIDFILE="/var/run/dnsmasq.pid"
      EOH
      expect(chef_run).to create_file('/etc/init.d/dnsmasq')
        .with(mode: '0755', content: expected)
    end
  end

  context 'the default action ([:create, :enable, :start])' do
    include_context description

    it_behaves_like 'init script patching'
  end

  context 'the :create action' do
    include_context description

    it_behaves_like 'init script patching'
  end

  context 'the :remove action' do
    include_context description

    it 'deletes the dnsmasq init script' do
      expect(chef_run).to delete_file('/etc/init.d/dnsmasq')
    end
  end
end
