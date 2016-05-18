# Encoding: UTF-8
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_config
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

class Chef
  class Provider
    # A Chef provider for generating Dnsmasq configs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalConfig < LWRPBase
      use_inline_resources

      provides :dnsmasq_local_config if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Create Dnsmasq's config directory and render a dns.conf config file
      # in it.
      #
      action :create do
        directory '/etc/dnsmasq.d'
        merged_config = new_resource.config.merge(
          new_resource.state.select { |k, _| k != :config }
        )
        file '/etc/dnsmasq.d/dns.conf' do
          content config_body_for(merged_config)
        end
      end

      #
      # Delete Dnsmasq's config directory.
      #
      action :remove do
        directory '/etc/dnsmasq.d' do
          recursive true
          action :delete
        end
      end

      #
      # Take a config hash and turn it into a proper Dnsmasq config file body.
      #
      # @param config [Hash] a config hash
      #
      # @return [String] a config file body
      #
      def config_body_for(config)
        Hash[config.sort].map do |k, v|
          case v
          when TrueClass, FalseClass
            k.to_s.tr('_', '-') if v
          when String, Fixnum
            "#{k.to_s.tr('_', '-')}=#{v}"
          else
            raise(Exceptions::ValidationFailed, "Invalid: '#{k}' => '#{v}'")
          end
        end.compact.join("\n")
      end
    end
  end
end
