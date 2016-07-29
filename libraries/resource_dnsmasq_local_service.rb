# Encoding: UTF-8
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
require 'chef/resource/lwrp_base'

class Chef
  class Resource
    # A Chef resource for acting on the dnsmasq service.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalService < LWRPBase # rubocop:disable Style/Documentation
      self.resource_name = :dnsmasq_local_service
      actions Chef::Resource::Service.new('_', nil).allowed_actions + \
              [:create, :remove].uniq
      default_action [:create, :enable, :start]

      #
      # Allow the user to pass in either hash of command-line options to be
      # passed to dnsmasq. This is necessary because there are some options
      # that can only be set as switches and have no equivalent that can live
      # in a dnsmasq.conf.
      #
      # Following Chef attribute style, options should be passed in with
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
      attribute :options, kind_of: Hash, default: {}

      #
      # Allow individual attributes to be fed in and merged with the default
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
      # Add a newly-declared attribute into the list of desired state
      # attributes to account for the fact that Chef 12 defaults this to true
      # while 11 defaults it to false.
      #
      # @param attr [Symbol] the new attribute to add to the list of state ones
      #
      def add_state_attr(attr)
        new_attrs = (self.class.state_attrs << attr).uniq
        self.class.state_attrs(*new_attrs)
      end
    end
  end
end unless defined?(Chef::Resource::DnsmasqLocalService)
# Don't let this class be reloaded or strange things happen to the custom
# attributes we've loaded in via `method_missing`.
