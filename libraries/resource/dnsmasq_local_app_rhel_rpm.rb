# frozen_string_literal: true

# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_app_rhel_rpm
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
    # A Dnsmasq package resouce specific to RHEL6, whose %preun script tries
    # to check the status of the service we've already removed by the time it
    # runs.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalAppRhelRpm < DnsmasqLocalAppRhel
      provides :dnsmasq_local_app,
               platform_family: 'rhel',
               platform_version: '< 7'

      #
      # Remove the Dnsmasq package.
      #
      action :remove do
        rpm_package 'dnsmasq' do
          options '--noscripts'
          action :remove
        end
      end
    end
  end
end
