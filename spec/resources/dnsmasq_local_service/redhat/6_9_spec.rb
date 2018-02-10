# frozen_string_literal: true

require_relative '../redhat'

describe 'resources::dnsmasq_local_service::redhat::6_9' do
  include_context 'resources::dnsmasq_local_service::redhat'

  let(:platform_version) { '6.9' }

  it_behaves_like 'any Red Hat platform'

  shared_examples_for 'init script patching' do
    before(:each) do
      allow(File).to receive(:read).and_call_original
      orig = <<-ORIG.gsub(/^ {8}/, '')
        DOMAIN_SUFFIX=`dnsdomainname`
        if [ ! -z "${DOMAIN_SUFFIX}" ]; then
          OPTIONS="-s $DOMAIN_SUFFIX"
        fi

        RETVAL=0

        PIDFILE="/var/run/dnsmasq.pid"

        # See how we were called.
        case "$1" in
          start)
                if [ $UID -ne 0 ] ; then
                    echo "User has insufficient privilege."
                    exit 4
                fi
                echo -n "Starting dnsmasq: "
                daemon $dnsmasq $OPTIONS
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && touch /var/lock/subsys/dnsmasq
                ;;
          stop)
                if test "x`pidfileofproc dnsmasq`" != x; then
                    echo -n "Shutting down dnsmasq: "
                    killproc dnsmasq
                fi
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/dnsmasq $PIDFILE
                ;;
      ORIG
      allow(File).to receive(:read).with('/etc/init.d/dnsmasq')
                                   .and_return(orig)
    end

    it 'patches the dnsmasq init script' do
      expected = <<-EXP.gsub(/^ {8}/, '')
        DOMAIN_SUFFIX=`dnsdomainname`
        if [ ! -z "${DOMAIN_SUFFIX}" ]; then
          OPTIONS="-s $DOMAIN_SUFFIX"
        fi

        . /etc/default/dnsmasq

        [ -n "$DNSMASQ_OPTS" ] && OPTIONS="$OPTIONS $DNSMASQ_OPTS"

        RETVAL=0

        PIDFILE="/var/run/dnsmasq.pid"

        # See how we were called.
        case "$1" in
          start)
                if [ $UID -ne 0 ] ; then
                    echo "User has insufficient privilege."
                    exit 4
                fi
                echo -n "Starting dnsmasq: "
                mkdir -p /var/run/dnsmasq
                cp /etc/resolv.conf /var/run/dnsmasq/resolv.conf
                daemon $dnsmasq -r /var/run/dnsmasq/resolv.conf $OPTIONS
                RETVAL=$?
                echo
                if [ $RETVAL -eq 0 ]; then
                  touch /var/lock/subsys/dnsmasq
                  cp /var/run/dnsmasq/resolv.conf /var/run/dnsmasq/resolv.conf.new
                  sed -i '/^nameserver/d' /var/run/dnsmasq/resolv.conf.new
                  echo nameserver 127.0.0.1 >> /var/run/dnsmasq/resolv.conf.new
                  cp /var/run/dnsmasq/resolv.conf.new /etc/resolv.conf
                fi
                ;;
          stop)
                if test "x`pidfileofproc dnsmasq`" != x; then
                    echo -n "Shutting down dnsmasq: "
                    cp /var/run/dnsmasq/resolv.conf /etc/resolv.conf
                    killproc dnsmasq
                fi
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && rm -rf /var/lock/subsys/dnsmasq /var/run/dnsmasq
                ;;
      EXP
      expect(chef_run).to create_file('/etc/init.d/dnsmasq')
        .with(mode: '0755', content: expected)
    end
  end

  context 'the default action' do
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
