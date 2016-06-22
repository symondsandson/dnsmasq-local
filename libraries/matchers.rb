# Encoding: UTF-8
#
# Cookbook Name:: dnsmasq-local
# Library:: matchers
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

if defined?(ChefSpec)
  {
    dnsmasq_local: [:create, :remove],
    dnsmasq_local_app: [:install, :remove],
    dnsmasq_local_config: [:create, :remove],
    dnsmasq_local_service: [
      :create, :remove, :enable, :disable, :stop, :start, :restart
    ]
  }.each do |matcher, actions|
    ChefSpec.define_matcher(matcher)

    actions.each do |action|
      define_method("#{action}_#{matcher}") do |name|
        ChefSpec::Matchers::ResourceMatcher.new(matcher, action, name)
      end
    end
  end
end
