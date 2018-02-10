# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_service
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

require 'chef/resource/service'
require 'chef/resource'

class Chef # rubocop:disable Style/MultilineIfModifier
  class Resource
    # A Chef resource for acting on the dnsmasq service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalService < Resource # rubocop:disable Style/Documentation
      default_action %i[create enable start]

      #
      # Allow the user to pass in either hash of command-line options to be
      # passed to dnsmasq. This is necessary because there are some options
      # that can only be set as switches and have no equivalent that can live
      # in a dnsmasq.conf.
      #
      # Following Chef property style, options should be passed in with
      # underscores in place of dashes and will be converted by the provider,
      # e.g.:
      #
      #   dnsmasq_local_service 'default' do
      #     options(bind_dynamic: true, all_servers: true)
      #   end
      #
      #   dnsmasq_local_service 'default' do
      #     options(enable_dbus: 'uk.org.thekelleys.dnsmasq')
      #   end
      #
      # Only the longform names of these switches are supported.
      #
      property :options, Hash, default: {}

      #
      # Supporting populating the `/etc/default/dnsmasq` file with any other
      # arbitrary environment variables. It is up to the user to ensure the
      # variables are valid and used by the version of Dnsmasq on their
      # platform. The only environment variable that cannot be set here is
      # DNSMASQ_OPTS, as that is controlled by the options property above.
      #
      property :environment,
               Hash,
               default: {},
               callbacks: {
                 'Invalid environment variable: DNSMASQ_OPTS' => lambda { |v|
                   !v.keys.map(&:to_s).include?('DNSMASQ_OPTS')
                 }
               }

      #
      # Allow individual properties to be fed in and merged with the default
      # command line options without blowing away the entire hash.
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        if block.nil? && args.length == 1 && !method_symbol.match(/^to_/)
          self.class.property(method_symbol, kind_of: args[0].class)
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
      # Tell NetworkManager to relinquish control of Dnsmasq, if applicable,
      # and generate the `/etc/default/dnsmasq` file for the service.
      #
      action :create do
        if shell_out('pgrep NetworkManager').exitstatus.zero?
          service 'NetworkManager' do
            supports(status: true, restart: true)
            action :nothing
          end
          file '/etc/NetworkManager/conf.d/20-dnsmasq.conf' do
            content "[main]\ndns=none"
            notifies :restart, 'service[NetworkManager]', :immediately
          end
        end
        extras = new_resource.class.state_properties.map(&:name)
        extras.delete(:options)
        extras.delete(:environment)
        extras.delete_if { |p| new_resource.send(p).nil? }
        merged_options = new_resource.options.merge(
          extras.each_with_object({}) do |p, hsh|
            hsh[p] = new_resource.send(p)
          end
        )
        file '/etc/default/dnsmasq' do
          content(defaults_file_content(merged_options,
                                        new_resource.environment))
        end
      end

      #
      # Clean up the NetworkManager config, if appilcable, and the defaults
      # file.
      #
      action :remove do
        file('/etc/default/dnsmasq') { action :delete }
        if shell_out('pgrep NetworkManager').exitstatus.zero?
          service 'NetworkManager' do
            supports(status: true, restart: true)
            action :nothing
          end
          file '/etc/NetworkManager/conf.d/20-dnsmasq.conf' do
            action :delete
            notifies :restart, 'service[NetworkManager]', :immediately
          end
        end
      end

      #
      # Every action that isn't :create or :remove should be passed on to a
      # standard Chef service resource.
      #
      Chef::Resource::Service.allowed_actions.each do |a|
        action(a) do
          service "#{a} dnsmasq" do
            service_name 'dnsmasq'
            supports restart: true, status: true
            action a
          end
        end
      end

      #
      # Return a rendered /etc/default/dnsmasq based on a set of options.
      #
      # @param opts [Hash] a set of dnsmasq command line options
      # @param env [Hash] a set of other environment variables
      #
      def defaults_file_content(opts, env)
        header = <<-HEADER.gsub(/^ +/, '').rstrip
          # This file is managed by Chef.
          # Any changes to it will be overwritten.
        HEADER
        [
          header, options_string(opts), environment_string(env)
        ].compact.join("\n")
      end

      #
      # Render the options hash as a string.
      #
      # @param opts [Hash] the contents of the options property
      #
      # @return [String] that hash rendered for file output
      #
      def options_string(opts)
        str_list = opts.map do |k, v|
          if v == true
            "--#{k.to_s.tr('_', '-')}"
          elsif v
            "--#{k.to_s.tr('_', '-')}=#{v}"
          end
        end.compact
        "DNSMASQ_OPTS='#{str_list.join(' ')}'"
      end

      #
      # Render the environment hash as a string.
      #
      # @param env [Hash] the contents of the environment property
      #
      # @return [String, NilClass] that hash rendered for file output or nil
      #
      def environment_string(env)
        return nil if env.empty?
        env.map { |k, v| "#{k}='#{v}'" }.join("\n")
      end
    end
  end
end unless defined?(Chef::Resource::DnsmasqLocalService)
# Don't let this class be reloaded or strange things happen to the custom
# property we've loaded in via `method_missing`.
