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
      # Generate the `/etc/default/dnsmasq` file for the service.
      #
      action :create do
        merged_env = new_resource.environment.merge(
          new_resource.state.select { |k, v| k != :environment && !v.nil? }
        )
        file '/etc/default/dnsmasq' do
          header = <<-EOH.gsub(/^ +/, '')
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
          EOH
          body = Hash[merged_env.sort].map { |k, v| "#{k.upcase}='#{v}'" }
                 .join("\n")
          content(header + body)
        end
        file '/etc/init.d/dnsmasq' do
          mode '0755'
          content lazy {
            orig = ::File.read('/etc/init.d/dnsmasq')
            lines = orig.lines
            idx = lines.index { |l| l.strip == 'RETVAL=0' }

            lines.insert(idx, "\n")
            {
              'DNSMASQ_OPTS' => nil,
              'CONFIG_DIR' => '-7',
              'CACHESIZE' => '-c',
              'RESOLV_CONF' => '-r',
              'DOMAIN_SUFFIX' => '-s',
              'DHCP_LEASE' => '-l',
              'DNSMASQ_INTERFACES' => nil,
              'DNSMASQ_USER' => '-u',
              'MAILTARGET' => '-t',
              'MAILHOSTNAME' => '-m',
            }.each do |opt, switch|
              newline = "[ -n \"$#{opt}\" ] && " \
                        "OPTIONS=\"$OPTIONS #{switch}#{' ' if switch}$#{opt}" \
                        "\"\n"
              lines.insert(idx, newline) unless lines.include?(newline)
            end
            lines.insert(idx, "\n")
            newstr = <<-EOH.gsub(/^ {14}/, '')
              for INTERFACE in $DNSMASQ_EXCEPT; do
                DNSMASQ_INTERFACES="$DNSMASQ_INTERFACES -I $INTERFACE"
              done
            EOH
            lines.insert(idx, newstr) unless orig.include?(newstr)
            lines.insert(idx, "\n")
            newstr = <<-EOH.gsub(/^ {14}/, '')
              for INTERFACE in $DNSMASQ_INTERFACE; do
                DNSMASQ_INTERFACES="$DNSMASQ_INTERFACES -i $INTERFACE"
              done
            EOH
            lines.insert(idx, newstr) unless orig.include?(newstr)
            lines.insert(idx, "\n")
            newstr = ". /etc/default/dnsmasq\n"
            lines.insert(idx, newstr) unless lines.include?(newstr)
            lines.join
          }
        end
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        %w(/etc/default/dnsmasq /etc/init.d/dnsmasq).each do |f|
          file(f) { action :delete }
        end
      end
    end
  end
end
