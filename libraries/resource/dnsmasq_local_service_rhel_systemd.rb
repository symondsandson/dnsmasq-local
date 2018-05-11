# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_service_rhel_systemd
#
# Copyright 2016, Socrata, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative 'dnsmasq_local_service_systemd'

class Chef
  class Resource
    # A Chef resource for Systemd RHEL services.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceRhelSystemd < DnsmasqLocalServiceSystemd
      provides :dnsmasq_local_service do |node|
        node.platform_family?('rhel') && \
          Chef::Platform::ServiceHelpers.service_resource_providers
                                        .include?(:systemd)
      end

      #
      # Generate the `/etc/default/dnsmasq` file and patch usage of it into the
      # Systemd unit.
      #
      action :create do
        super()

        execute 'systemctl daemon-reload' do
          action :nothing
        end
        directory '/etc/systemd/system/dnsmasq.service.d'
        file '/etc/systemd/system/dnsmasq.service.d/local.conf' do
          content <<-CONTENT.gsub(/^ {12}/, '').strip
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
          CONTENT
          notifies :run, 'execute[systemctl daemon-reload]', :immediately
        end
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        file '/etc/systemd/system/dnsmasq.service.d/local.conf' do
          action :delete
        end
        directory('/etc/systemd/system/dnsmasq.service.d') { action :delete }
        super()
      end
    end
  end
end
