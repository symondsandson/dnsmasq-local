# encoding: utf-8
# frozen_string_literal: true#

# Cookbook Name:: dnsmasq-local
# Library:: provider_dnsmasq_local_app_rhel
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

require_relative 'provider_dnsmasq_local_app'

class Chef
  class Provider
    # A Dnsmasq package provider specific to RHEL platforms.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalAppRhel < DnsmasqLocalApp
      provides :dnsmasq_local_app, platform_family: 'rhel' if defined?(provides)

      #
      # Remove the Dnsmasq package.
      #
      action :remove do
        package('dnsmasq') { action :remove }
      end
    end
  end
end
