# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_app_debian
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

require_relative 'dnsmasq_local_app'

class Chef
  class Resource
    # A Dnsmasq package resource specific to Debian platforms.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalAppDebian < DnsmasqLocalApp
      provides :dnsmasq_local_app, platform_family: 'debian'

      #
      # Force APT to leave the Chef-generated config file in place.
      #
      action :install do
        package 'dnsmasq' do
          version new_resource.version unless new_resource.version.nil?
          options '-o Dpkg::Options::=--force-confold'
        end
      end

      #
      # Force APT to leave the Chef-generated config file in place.
      #
      action :upgrade do
        package 'dnsmasq' do
          options '-o Dpkg::Options::=--force-confold'
          action :upgrade
        end
      end

      #
      # Purge the Dnsmasq Debian packages.
      #
      action :remove do
        %w[dnsmasq dnsmasq-base].each { |p| package(p) { action :purge } }
      end
    end
  end
end
