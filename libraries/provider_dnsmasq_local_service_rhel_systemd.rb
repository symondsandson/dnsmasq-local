# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_service_rhel_systemd
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

require_relative 'provider_dnsmasq_local_service'

class Chef
  class Provider
    # A Chef provider for Systemd RHEL services.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceRhelSystemd < DnsmasqLocalService
      if defined?(provides)
        provides :dnsmasq_local_service,
                 platform_family: 'rhel',
                 platform_version: '>= 7'
      end

      #
      # Generate the `/etc/default/dnsmasq` file for the service.
      #
      action :create do
        super()
        execute 'systemctl daemon-reload' do
          action :nothing
        end
        file '/usr/lib/systemd/system/dnsmasq.service' do
          content lazy {
            orig = ::File.read('/usr/lib/systemd/system/dnsmasq.service')
            lines = orig.lines
            idx = lines.index { |l| l.start_with?('ExecStart') }
            lines.insert(idx, "EnvironmentFile=/etc/default/dnsmasq\n")
            lines.join

            idx = lines.index do |l|
              l.strip == 'ExecStart=/usr/sbin/dnsmasq -k'
            end
            lines[idx] = lines[idx].strip + " $DNSMASQ_OPTS\n" if idx
            lines.join
          }
          notifies :run, 'execute[systemctl daemon-reload]', :immediately
        end
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        super()
        file('/usr/lib/systemd/system/dnsmasq.service') { action :delete }
      end
    end
  end
end
