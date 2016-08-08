# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local
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
    # A main Chef provider for Dnsmasq installation and configuration.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocal < LWRPBase
      use_inline_resources

      provides :dnsmasq_local if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install and configure Dnsmasq. Drop in the config first so DNS
      # doesn't break in the event of an unusable default config.
      #
      action :create do
        dnsmasq_local_config new_resource.name do
          new_resource.config.each { |k, v| send(k, v) }
          notifies :restart, "dnsmasq_local_service[#{new_resource.name}]"
        end
        dnsmasq_local_app new_resource.name do
          notifies :restart, "dnsmasq_local_service[#{new_resource.name}]"
        end
        dnsmasq_local_service new_resource.name do
          new_resource.options.each { |k, v| send(k, v) }
          notifies :restart, "dnsmasq_local_service[#{new_resource.name}]"
        end
      end

      #
      # Uninstall Dnsmasq and any configs.
      #
      action :remove do
        dnsmasq_local_service new_resource.name do
          action [:stop, :disable, :remove]
        end
        dnsmasq_local_config(new_resource.name) { action :remove }
        dnsmasq_local_app(new_resource.name) { action :remove }
      end
    end
  end
end
