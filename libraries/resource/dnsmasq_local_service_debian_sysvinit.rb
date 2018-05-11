# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_service_debian_sysvinit
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

require_relative 'dnsmasq_local_service'

class Chef
  class Resource
    # A Chef resource for Debian's Dnsmasq service specifics.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceDebianSysvinit < DnsmasqLocalService
      provides :dnsmasq_local_service do |node|
        node.platform_family?('debian') && \
          !Chef::Platform::ServiceHelpers.service_resource_providers
                                         .include?(:systemd)
      end
    end
  end
end
