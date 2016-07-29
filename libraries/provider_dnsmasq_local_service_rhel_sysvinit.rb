# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_service_rhel_sysvinit
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
    # A Chef provider for Sysvinit RHEL services.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceRhelSysvinit < DnsmasqLocalService
      if defined?(provides)
        provides :dnsmasq_local_service,
                 platform_family: 'rhel',
                 platform_version: '< 7'
      end

      #
      # Patch the RHEL < 7 init script to pass on the DNSMASQ_OPTS environment
      # variable set in /etc/default/dnsmasq.
      #
      # (see Chef::Provider::DnsmasqLocalService#action_create)
      #
      action :create do
        super()
        file '/etc/init.d/dnsmasq' do
          mode '0755'
          content lazy {
            lines = ::File.read('/etc/init.d/dnsmasq').lines
            idx = lines.index { |l| l.strip == 'RETVAL=0' }

            nl = '[ -n "$DNSMASQ_OPTS" ] && OPTIONS="$OPTIONS $DNSMASQ_OPTS"'
            lines.insert(idx, "\n#{nl}\n\n") unless lines.include?("#{nl}\n")

            nl = '. /etc/default/dnsmasq'
            lines.insert(idx, "#{nl}\n") unless lines.include?("#{nl}\n")
            lines.join
          }
        end
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        super()
        file('/etc/init.d/dnsmasq') { action :delete }
      end
    end
  end
end
