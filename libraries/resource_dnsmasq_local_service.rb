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
      # Set up a default hash of environment variables that a user can
      # override in its entirety by passing in a new one. Every key set will be
      # upcased and written out to `/etc/default/dnsmasq` on Ubuntu nodes.
      #
      attribute :environment,
                kind_of: Hash,
                default: {
                  enabled: 1,
                  config_dir: '/etc/dnsmasq.d,.dpkg-dist,.dpkg-old,.dpkg-new'
                }

      #
      # Allow individual attributes to be fed in and merged with the default
      # environment without blowing away the entire thing.
      #
      # (see Chef::Resource#method_missing)
      #
      def method_missing(method_symbol, *args, &block)
        if block.nil? && args.length == 1
          self.class.attribute method_symbol, kind_of: args[0].class
          add_state_attr(method_symbol)
          send(method_symbol, args[0]) unless args[0].nil?
        else
          super
        end
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
