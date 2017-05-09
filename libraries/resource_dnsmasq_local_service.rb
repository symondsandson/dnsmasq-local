# encoding: utf-8
# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource_dnsmasq_local_service
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

class Chef
  class Resource
    # A Chef resource for acting on the dnsmasq service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalService < Service
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
      # Allow individual properties to be fed in and merged with the default
      # options without blowing away the entire hash.
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        if block.nil? && args.length == 1 && !method_symbol.match(/^to_/)
          self.class.attribute method_symbol, kind_of: args[0].class
          add_state_attr(method_symbol)
          send(method_symbol, args[0]) unless args[0].nil?
        else
          super
        end
      end

      #
      # Respond to missing methods.
      #
      # (see Object#respond_to_missing?)
      #
      def respond_to_missing?(method_symbol, *args, &block)
        block.nil? && args.length == 1 && !method_symbol.match(/^to_/) || super
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
          directory '/etc/NetworkManager/conf.d'
          file '/etc/NetworkManager/conf.d/20-dnsmasq.conf' do
            content "[main]\ndns=none"
            notifies :restart, 'service[NetworkManager]', :immediately
          end
        end
        merged_options = new_resource.options.merge(
          new_resource.state.select { |k, v| k != :options && !v.nil? }
        )
        file '/etc/default/dnsmasq' do
          header = <<-EOH.gsub(/^ +/, '')
            # This file is managed by Chef.
            # Any changes to it will be overwritten.
          EOH
          opts_str = merged_options.map do |k, v|
            if v == true
              "--#{k.to_s.tr('_', '-')}"
            elsif v
              "--#{k.to_s.tr('_', '-')}=#{v}"
            end
          end.compact.join(' ')
          content(header + "DNSMASQ_OPTS='#{opts_str}'")
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
      Resource::DnsmasqLocalService.allowed_actions.each do |a|
        next if %i[create remove].include?(a)
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
end unless defined?(Chef::Resource::DnsmasqLocalService)
# Don't let this class be reloaded or strange things happen to the custom
# attributes we've loaded in via `method_missing`.
