# Encoding: UTF-8
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_app
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

require 'chef/dsl/include_recipe'
require 'chef/provider/lwrp_base'

class Chef
  class Provider
    # A Chef provider for managing the Dnsmasq package.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalApp < LWRPBase
      include Chef::DSL::IncludeRecipe

      use_inline_resources

      provides :dnsmasq_local_app if defined?(provides)

      #
      # WhyRun is supported by this provider
      #
      # (see Chef::Provider#whyrun_supported?)
      #
      def whyrun_supported?
        true
      end

      #
      # Install the Dnsmasq package.
      #
      action :install do
        include_recipe 'apt'
        package 'dnsmasq'
      end

      #
      # Purge the Dnsmasq packages.
      #
      action :remove do
        %w(dnsmasq dnsmasq-base).each { |p| package(p) { action :purge } }
      end
    end
  end
end
