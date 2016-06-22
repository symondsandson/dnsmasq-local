# Encoding: UTF-8
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_service
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

require 'chef/provider/lwrp_base'
require_relative 'resource_dnsmasq_local_service'

class Chef
  class Provider
    # A Chef provider for acting on the dnsmasq service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalService < LWRPBase
      use_inline_resources

      provides :dnsmasq_local_service if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Generate the `/etc/default/dnsmasq` file for the service.
      #
      action :create do
        merged_env = new_resource.environment.merge(
          new_resource.state.select { |k, v| k != :environment && !v.nil? }
        )
        file '/etc/default/dnsmasq' do
          c = Hash[merged_env.sort].map { |k, v| "#{k.upcase}='#{v}'" }
                                   .join("\n")
          content c
        end
      end

      #
      # Clean up the service files that are managed by Chef.
      #
      action :remove do
        file('/etc/default/dnsmasq') { action :delete }
      end

      #
      # Every action that isn't :create or :remove should be passed on to a
      # standard Chef service resource.
      #
      Resource::DnsmasqLocalService.new('_', nil).allowed_actions.each do |a|
        next if [:create, :remove].include?(a)
        action(a) do
          service "#{a} dnsmasq" do
            service_name 'dnsmasq'
            supports restart: true, status: true
            action a
          end
        end
      end
    end
  end
end
