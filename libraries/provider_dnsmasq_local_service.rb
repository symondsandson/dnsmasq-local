# encoding: utf-8
# frozen_string_literal: true
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

require 'chef/mixin/shell_out'
require 'chef/provider/lwrp_base'
require_relative 'resource_dnsmasq_local_service'

class Chef
  class Provider
    # A Chef provider for acting on the dnsmasq service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalService < LWRPBase
      include Chef::Mixin::ShellOut

      use_inline_resources

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
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
