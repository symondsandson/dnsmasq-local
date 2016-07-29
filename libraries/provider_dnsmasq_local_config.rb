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
        file '/etc/dnsmasq.conf' do
          content <<-EOH.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            conf-dir=/etc/dnsmasq.d
          EOH
        end
        directory '/etc/dnsmasq.d'
        merged_config = new_resource.config.merge(
          new_resource.state.select { |k, v| k != :config && !v.nil? }
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
        res = <<-EOH.gsub(/^ +/, '')
          # This file is managed by Chef.
          # Any changes to it will be overwritten.
        EOH
        res << Hash[config.sort].map { |k, v| config_for(k, v) }.compact
               .join("\n")
      end

      #
      # Take a config key and value and return the dnsmasq.conf-compatible
      # string representation of them.
      #
      # @param key [Symbol, String] the dnsmasq config key
      # @param val [TrueClass, FalseClass, String, Fixnum, Array] the value(s)
      #
      # @return [String, NilClass] the rendered config string or nil for an
      #                            empty one
      #
      def config_for(key, val)
        case val
        when TrueClass, FalseClass then key.to_s.tr('_', '-') if val
        when String, Fixnum then "#{key.to_s.tr('_', '-')}=#{val}"
        when Array then val.map { |v| config_for(key, v) }.join("\n")
        when Hash then config_for(key, val.keys.select { |k| val[k] })
        else raise(Exceptions::ValidationFailed,
                   "Invalid: '#{key}' => '#{val}'")
        end
      end
    end
  end
end
