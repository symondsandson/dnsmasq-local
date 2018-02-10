# frozen_string_literal: true

# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_app_rhel_yum
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

require_relative 'dnsmasq_local_app_rhel'

class Chef
  class Resource
    # A Dnsmasq package resouce specific to RHEL7+, where we don't need
    # the same hackery at uninstall time as with RHEL6.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalAppRhelYum < DnsmasqLocalAppRhel
      provides :dnsmasq_local_app,
               platform_family: 'rhel',
               platform_version: '>= 7'

      #
      # Remove the Dnsmasq package.
      #
      action :remove do
        package('dnsmasq') { action :remove }
      end
    end
  end
end
