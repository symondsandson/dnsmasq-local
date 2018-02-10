# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_app
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

class Chef
  class Resource
    # A Chef resource for managing the Dnsmasq package.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalApp < Resource
      default_action :install

      #
      # Allow the user to specify a package version to install.
      #
      property :version, String

      #
      # Install the Dnsmasq package.
      #
      action :install do
        package 'dnsmasq' do
          version new_resource.version unless new_resource.version.nil?
        end
      end

      #
      # Upgrade the Dnsmasq package.
      #
      action :upgrade do
        package('dnsmasq') { action :upgrade }
      end
    end
  end
end
