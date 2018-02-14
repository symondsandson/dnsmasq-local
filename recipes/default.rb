# frozen_string_literal: true

#
# Cookbook Name:: dnsmasq-local
# Recipe:: default
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

config = node['dnsmasq_local']['config']
options = node['dnsmasq_local']['options']
environment = node['dnsmasq_local']['environment']

dnsmasq_local 'default' do
  config config unless config.empty?
  options options unless options.empty?
  environment environment unless environment.empty?
end
