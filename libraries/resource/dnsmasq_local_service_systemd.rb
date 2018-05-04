# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Library:: resource/dnsmasq_local_service_systemd
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
    # A Chef resource for Systemd platforms.
    #
    # @author Jonathan Hartman <jonathan.hartman@socrata.com>
    class DnsmasqLocalServiceSystemd < DnsmasqLocalService
      #
      # On Systemd platforms, we need to check if systemd-resolved is installed
      # and, if so, disable it. Otherwise it'll fight with dnsmasq over port
      # 53.
      #
      action :enable do
        if ::File.exist?('/lib/systemd/system/systemd-resolved.service')
          service('systemd-resolved') { action %i[stop disable] }
        end
        super()
      end

      # We can't be sure what the original state of systemd-resolved was prior
      # to the original :enable action, so we can't try to restore it as part
      # of the :disable action.
    end
  end
end
