# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_config
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

require 'chef/resource'

class Chef # rubocop:disable Style/MultilineIfModifier
  class Resource
    # A Chef resource for generating Dnsmasq configs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalConfig < Resource # rubocop:disable Style/Documentation
      provides :dnsmasq_local_config

      default_action :create

      #
      # The filename for this snippet of config. The resultant path to the
      # config file will be "/etc/dnsmasq.d/#{filename}".
      #
      property :filename,
               String,
               default: lazy { |r|
                 r.name.end_with?('.conf') ? r.name : "#{r.name}.conf"
               }

      #
      # Set up a default config property hash that can overridden in its
      # entirety by the user passing in a new one. The default config will:
      #
      #   * Listen only on the loopback interface
      #   * Disable caching
      #   * Do not create DNS for entries in /etc/hosts
      #   * Bind only to the interfaces being listened on
      #   * Use a static reply port instead of randomly generating one for each
      #     query. This does pose a security risk for publicly-exposed servers
      #     (Don't run this there!), but ensures the return port will always
      #     be in the system's ephemeral range for ACLs that enforce as much.
      #
      # Because of the annoyance of Dnsmasq using hyphens in multi-word keys,
      # we accept them here with underscores and will translate them before
      # rendering the final config file.
      #
      property :config,
               Hash,
               default: {
                 interface: '',
                 cache_size: 0,
                 no_hosts: true,
                 bind_interfaces: true,
                 query_port: 0
               }

      #
      # Allow individual properties to be fed in so that they're merged with
      # the default config but don't totally blow it away.
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        if block.nil? && args.length == 1 && !method_symbol.match(/^to_/)
          self.class.property(method_symbol, args[0].class)
          send(method_symbol, args[0]) unless args[0].nil?
        else
          super
        end
      end

      #
      # The property calls in method_missing do all the work for this.
      #
      # (see Object#respond_to_missing?)
      #
      def respond_to_missing?(method_symbol, include_private = false)
        super
      end

      #
      # Create Dnsmasq's config directory and render a config file in it.
      #
      action :create do
        file '/etc/dnsmasq.conf' do
          content <<-CONTENT.gsub(/^ +/, '').strip
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
            conf-dir=/etc/dnsmasq.d
          CONTENT
        end
        directory '/etc/dnsmasq.d'
        extras = new_resource.class.state_properties.map(&:name)
        %i[filename config].each { |p| extras.delete(p) }
        extras.delete_if { |p| new_resource.send(p).nil? }
        merged_config = new_resource.config.merge(
          extras.each_with_object({}) do |p, hsh|
            hsh[p] = new_resource.send(p)
          end
        )
        file ::File.join('/etc/dnsmasq.d', new_resource.filename) do
          content config_body_for(merged_config)
        end
      end

      #
      # Delete Dnsmasq's config file and the config directory if it's empty.
      #
      action :remove do
        file(::File.join('/etc/dnsmasq.d', new_resource.filename)) do
          action :delete
        end

        # To make this delete idempotent, we need to take action whether the
        # config file's already been deleted on a previous run or not.
        entries = ::Dir.exist?('/etc/dnsmasq.d') && \
                  ::Dir.entries('/etc/dnsmasq.d')
        entries.delete(new_resource.filename) if entries
        if entries && entries.sort == %w[. ..]
          directory('/etc/dnsmasq.d') { action :delete }
          file('/etc/dnsmasq.conf') { action :delete }
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
        res = <<-CONTENT.gsub(/^ +/, '')
          # This file is managed by Chef.
          # Any changes to it will be overwritten.
        CONTENT
        res << Hash[config.sort].map { |k, v| config_for(k, v) }.compact
                                .join("\n")
      end

      #
      # Take a config key and value and return the dnsmasq.conf-compatible
      # string representation of them.
      #
      # @param key [Symbol, String] the dnsmasq config key
      # @param val [TrueClass, FalseClass, String, Integer, Array] the value(s)
      #
      # @return [String, NilClass] the rendered config string or nil for an
      #                            empty one
      #
      def config_for(key, val)
        case val
        when TrueClass, FalseClass then key.to_s.tr('_', '-') if val
        when String, Integer then "#{key.to_s.tr('_', '-')}=#{val}"
        when Array then val.map { |v| config_for(key, v) }.join("\n")
        when Hash then config_for(key, val.keys.select { |k| val[k] })
        else raise(Exceptions::ValidationFailed,
                   "Invalid: '#{key}' => '#{val}'")
        end
      end
    end
  end
end unless defined?(Chef::Resource::DnsmasqLocalConfig)
# Don't let this class be reloaded or strange things happen to the custom
# properties we've loaded in via `method_missing`.
