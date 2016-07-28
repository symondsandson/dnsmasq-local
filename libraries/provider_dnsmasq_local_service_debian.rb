# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_service_debian
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
    # A Chef provider for Debian's Dnsmasq service specifics.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceDebian < DnsmasqLocalService
      if defined?(provides)
        provides :dnsmasq_local_service, platform_family: 'debian'
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
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        file('/etc/default/dnsmasq') { action :delete }
      end
    end
  end
end
