# Encoding: UTF-8
#
# Cookbook Name:: dnsmasq-local
# Library:: resource_dnsmasq_local_config
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

require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A Chef resource for generating Dnsmasq configs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalConfig < LWRPBase
      self.resource_name = :dnsmasq_local_config
      actions :create, :remove
      default_action :create

      #
      # Set up a default config attribute hash that can overridden in its
      # entirety by the user passing in a new one. The default config will:
      #
      #   * Listen only on the loopback interface
      #   * Disable caching
      #   * Do not create DNS for entries in /etc/hosts
      #   * Bind only to the interfaces being listened on
      #   * Proxy DNSSEC, when available
      #   * Use a static reply port instead of randomly generating one for each
      #     query. This does pose a security risk for publicly-exposed servers
      #     (Don't run this there!), but ensures the return port will always
      #     be in the system's ephemeral range for ACLs that enforce as much.
      #
      # Because of the annoyance of Dnsmasq using hyphens in multi-word keys,
      # we accept them here with underscores and will translate them before
      # rendering the final config file.
      #
      attribute :config,
                kind_of: Hash,
                default: {
                  interface: '',
                  cache_size: 0,
                  no_hosts: true,
                  bind_interfaces: true,
                  proxy_dnssec: true,
                  query_port: 0
                }

      #
      # Allow individual attributes to be fed in so that they're merged with
      # the default config but don't totally blow it away.
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        if block.nil? && args.length == 1
          config[method_symbol] = args[0]
        else
          super
        end
      end
    end
  end
end
