# Encoding: UTF-8
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

# Create the config first so we don't risk DNS exploding when the package's
# postinstall script kicks in.
directory '/etc/dnsmasq.d'

file '/etc/dnsmasq.d/dns.conf' do
  content <<-EOH.gsub(/^ {4}/, '').strip
    interface=
    cache-size=0
    no-hosts
    bind-interfaces
    proxy-dnssec
    query-port=0
  EOH
  notifies :restart, 'service[dnsmasq]'
end

package 'dnsmasq'

service 'dnsmasq' do
  supports status: true, restart: true
  action [:enable, :start]
end
