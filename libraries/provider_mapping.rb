# encoding: utf-8
# frozen_string_literal: true
#
# Cookbook Name:: dnsmasq-local
# Library:: provider_mapping
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

require 'chef/version'
require 'chef/platform/provider_mapping'
require_relative 'provider_dnsmasq_local'
require_relative 'provider_dnsmasq_local_app_debian'
require_relative 'provider_dnsmasq_local_app_rhel'
require_relative 'provider_dnsmasq_local_config'
require_relative 'provider_dnsmasq_local_service_debian'
require_relative 'provider_dnsmasq_local_service_rhel_sysvinit'
require_relative 'provider_dnsmasq_local_service_rhel_systemd'

if Gem::Version.new(Chef::VERSION) < Gem::Version.new('12')
  Chef::Platform.set(
    resource: :dnsmasq_local,
    provider: Chef::Provider::DnsmasqLocal
  )
  [:ubuntu, :debian].each do |p|
    Chef::Platform.set(
      resource: :dnsmasq_local_app,
      platform: p,
      provider: Chef::Provider::DnsmasqLocalAppDebian
    )
  end
  [:redhat, :centos, :scientific].each do |p|
    Chef::Platform.set(
      resource: :dnsmasq_local_app,
      platform: p,
      provider: Chef::Provider::DnsmasqLocalAppRhel
    )
  end
  Chef::Platform.set(
    resource: :dnsmasq_local_config,
    provider: Chef::Provider::DnsmasqLocalConfig
  )

  [:ubuntu, :debian].each do |p|
    Chef::Platform.set(
      resource: :dnsmasq_local_service,
      platform: p,
      provider: Chef::Provider::DnsmasqLocalServiceDebian
    )
  end
  [:redhat, :centos, :scientific].each do |p|
    Chef::Platform.set(
      resource: :dnsmasq_local_service,
      platform: p,
      platform_version: '< 7',
      provider: Chef::Provider::DnsmasqLocalServiceRhelSysvinit
    )
    Chef::Platform.set(
      resource: :dnsmasq_local_service,
      platform: p,
      platform_version: '>= 7',
      provider: Chef::Provider::DnsmasqLocalServiceRhelSystemd
    )
  end
end
